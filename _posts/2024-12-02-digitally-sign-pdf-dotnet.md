---
layout: post
title: "Master PDF digital signing with eMudhra and Proxkey in .NET: step-by-step guide"
tags: dotnet csharp pdf digital-signature
image: /uploads/digitally-sign-pdf-dotnet/digitally-sign-pdf-dotnet.webp
---
One of my recent projects involved coding a simple .NET app that signs PDFs in bulk using Proxkey digital signature. These purchased CA verified digital signatures, like eMudhra and Proxkey, typically come with their own custom apps which can digitally sign PDFs. You can even use software like Adobe Reader for this purpose. However, the limitation is that you can only sign one PDF at a time.

If you want to send multiple digitally signed bills to customers via email, for instance, you'll need to write a custom program in .NET or Java. In this article, we’ll explore how to achieve this using .NET in Visual Studio.

## Preparing the environment.

We will use two open-source libraries to handle the cryptographic functionality:

- [itextsharp](https://www.nuget.org/packages/iTextSharp/5.5.13.3): You may use the latest version, but I chose this specific version for compatibility with my Visual Studio setup.
- [BouncyCastle](https://www.nuget.org/packages/BouncyCastle/1.8.9): The same applies to the BouncyCastle library.

Both libraries work together to retrieve the CA certificate, private key, and other cryptographic files from the thumb drive and then digitally sign each PDF.

## Setting up the Project

I created a simple form with a text box for the file path, a browse button, and a few options for the type of digital signature, such as "Proxkey" or "Self-signed." While self-signed certificates work well for testing and ad-hoc signing, they are not typically recommended for professional or commercial transactions, such as sending bills or purchase orders.

![form](/uploads/digitally-sign-pdf-dotnet/form.jpg)

When the user clicks the "Sign PDF" button, the app passes three parameters to the corresponding method:
1. The source PDF path.
2. The desired destination path.
3. (Optionally) the password for the self-signed PFX certificate, if applicable.

```csharp
if (optProxKey.Checked)
{
	Signer.SignPdfProxkey(sourcePdf, signedPdf);
}
else if (optSelfSigned.Checked)
{
	Signer.SignPdfSelfSign(sourcePdf, signedPdf, "digisign");
}
```

## Signing the PDF with Proxkey

The `Signer` class contains the code for Proxkey, but it should also work with other CA-provided digital signatures like eMudhra. Once you have the certificate thumbprint, fetch the corresponding certificate from the Windows certificate store (`X509Store` object).

The private key is then accessed using the `RSACryptoServiceProvider` object. The Proxkey or eMudhra software will automatically prompt you for the PIN, granting the program access to the private key certificate.

Use `appearance.SetVisibleSignature()` to print the visible (aesthetic) signature on the PDF. You can adjust variables like `rectWidth` and `rectHeight` to define the placement.

```csharp
public static void SignPdfProxkey(string inputPdf, string outputPdf)
{
	string thumbprint = getThumbPrint();
	if (thumbprint == null)
	{
		throw new InvalidOperationException("Thumbprint is not accessible. Ensure ProxKey middleware is installed and the token is connected.");
	}
	// Access the certificate from the Windows Certificate Store
	X509Store store = new X509Store(StoreName.My, StoreLocation.CurrentUser);
	store.Open(OpenFlags.ReadOnly);
	X509Certificate2 cert = null;

	foreach (X509Certificate2 c in store.Certificates)
	{
		if (c.Thumbprint != null && c.Thumbprint.Equals(thumbprint, StringComparison.OrdinalIgnoreCase))
		{
			cert = c;
			break;
		}
	}
	store.Close();

	if (cert == null)
	{
		throw new Exception("Certificate not found.");
	}

	// Authenticate with the USB token using the PIN and access the private key
	RSACryptoServiceProvider rsa = cert.PrivateKey as RSACryptoServiceProvider;
	if (rsa == null)
	{
		throw new InvalidOperationException("Private key is not accessible. Ensure ProxKey middleware is installed, the token is connected, and the correct PIN is used.");
	}

	// Perform a test operation to ensure the private key is accessible
	try
	{
		byte[] testData = new byte[] { 0x00, 0x01, 0x02, 0x03 };
		rsa.SignData(testData, new SHA256CryptoServiceProvider());
	}
	catch (CryptographicException ex)
	{
		throw new InvalidOperationException("Failed to authenticate with the USB token. Ensure the correct PIN is entered.", ex);
	}

	// Sign the PDF with iTextSharp
	using (FileStream inputFileStream = new FileStream(inputPdf, FileMode.Open, FileAccess.Read))
	using (FileStream outputFileStream = new FileStream(outputPdf, FileMode.Create, FileAccess.Write))
	{
		PdfReader reader = new PdfReader(inputFileStream);
		PdfStamper stamper = PdfStamper.CreateSignature(reader, outputFileStream, '\0');

		// Create the signature appearance
		PdfSignatureAppearance appearance = stamper.SignatureAppearance;
		appearance.Reason = "Document digitally signed";
		appearance.Location = "Vadodara";
		// Define the signature rectangle size
		iTextSharp.text.Rectangle pageSize = reader.GetPageSize(1); // Use 1 to get the size of the first page
		// Define the width and height of the page
		float pageWidth = pageSize.Width;
		float pageHeight = pageSize.Height; float rectWidth = 144f;
		float rectHeight = 32f;
		// Calculate the position for the bottom-right corner
		float left = pageWidth - rectWidth - 36; // 36 is some margin from the right edge
		float bottom = 276f; // 36 is the margin from the bottom edge

		appearance.SetVisibleSignature(new iTextSharp.text.Rectangle(left, bottom, left + rectWidth, bottom + rectHeight), 1, "Signature");

		// Convert the .NET certificate to a BouncyCastle certificate
		var bcCert = DotNetUtilities.FromX509Certificate(cert);
		IExternalSignature externalSignature = new PrivateKeySignature(rsa, "SHA-256");

		// Sign the document
		MakeSignature.SignDetached(appearance, externalSignature, new[] { bcCert }, null, null, null, 0, CryptoStandard.CMS);
	}
}
```

## Getting the thumb print

This helper function fetches the first available thumbprint with a private key from the certificate store.

```csharp
private static string getThumbPrint()
{
	X509Store store = new X509Store(StoreName.My, StoreLocation.CurrentUser);
	store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
	foreach (X509Certificate2 cert in store.Certificates)
	{

		if (cert.HasPrivateKey)
		{
			//cmbSignatures.Items.Add(cert.FriendlyName + " - " + cert.Thumbprint);
			return cert.Thumbprint;
		}
	}
	store.Close();
	return null;
}
```

## Self-signed certificate

While self-signed certificates are suitable for testing, they are not recommended for professional use. Here’s a basic implementation for self-signing:

```csharp
public static void SignPdfSelfSign(string inputPdf, string outputPdf, string password)
{

	var certificate = new X509Certificate2(@"cert\certificate.pfx", password, X509KeyStorageFlags.Exportable | X509KeyStorageFlags.PersistKeySet); 
	if (!certificate.HasPrivateKey)
	{
		throw new InvalidOperationException("No private key found in the certificate.");
	}
	// Convert .NET X509Certificate2 to BouncyCastle X509Certificate
	Org.BouncyCastle.X509.X509CertificateParser parser = new X509CertificateParser();
	Org.BouncyCastle.X509.X509Certificate bcCert = parser.ReadCertificate(certificate.RawData);
	//PdfReader reader = new PdfReader(inputPdf);
	using (PdfReader reader = new PdfReader(inputPdf))
	using (FileStream os = new FileStream(outputPdf, FileMode.Create, FileAccess.Write))
		{
			int totalPages = reader.NumberOfPages;
			int lastPageIndex = totalPages - 1;

			PdfStamper stamper = PdfStamper.CreateSignature(reader, os, '\0');

			// Get the signature appearance
			PdfSignatureAppearance appearance = stamper.SignatureAppearance;
			appearance.Reason = "Document digitally signed";
			appearance.Location = "Vadodara";

			// Define the signature rectangle size
			iTextSharp.text.Rectangle pageSize = reader.GetPageSize(1); // Use 1 to get the size of the first page
			// Define the width and height of the page
			float pageWidth = pageSize.Width;
			float pageHeight = pageSize.Height; float rectWidth = 144f;
			float rectHeight = 32f;
			// Calculate the position for the bottom-right corner
			float left = pageWidth - rectWidth - 36; // 36 is some margin from the right edge
			float bottom = 276f; // 36 is the margin from the bottom edge

			//appearance.SetVisibleSignature(new iTextSharp.text.Rectangle(36, 748, 144, 780), lastPageIndex, "SignatureField");
			appearance.SetVisibleSignature(new iTextSharp.text.Rectangle(left, bottom, left + rectWidth, bottom + rectHeight), 1, "SignatureField");


			// Extract the private key using BouncyCastle
			// Extract the private key using BouncyCastle
			var privateKey = GetPrivateKeyFromCertificate(certificate);
			//Org.BouncyCastle.Crypto.AsymmetricKeyParameter privateKey = DotNetUtilities.GetKeyPair(certificate.PrivateKey).Private;

			// Create the external signature container
			IExternalSignature pks = new CustomExternalSignature(certificate, DigestAlgorithms.SHA256);
			//IExternalSignature pks = new X509Certificate2Signature(certificate, "SHA-256");
			//var chain = new X509Certificate[] { certificate };  // You can fill this with the chain of certificates if needed
			ICollection<Org.BouncyCastle.X509.X509Certificate> chain = new List<Org.BouncyCastle.X509.X509Certificate> { bcCert };
			//ICollection<Org.BouncyCastle.X509.X509Certificate> chainCollection = chain;
			MakeSignature.SignDetached(appearance, pks, chain, null, null, null, 0, CryptoStandard.CMS);
		}
}
```

In order for this to work, you must create a `cert` subdirectory within the application directory which contains all certificate files needed for self-signing. You can create these files using `openssl` program as follows:

```bash
openssl genrsa -out private.key 2048
openssl req -new -key private.key -out request.csr -subj "/C=IN/ST=GUJ/L=Vadodara/O=ACME/OU=Unit/CN=ACME"
openssl x509 -req -days 365 -in request.csr -signkey private.key -out certificate.crt -extensions v3_req -extfile cert_config.cnf
openssl pkcs12 -export -out certificate.pfx -inkey private.key -in certificate.crt -password pass:digisign
```

Remember to replace ACME with your organization name and Vadodara with your region name. You can also replace the password "digisign" with something else - in which case you'll have to change the C# code above correspondingly.

## Notes on legal and regional compliance

Using self-signed certificates may not hold up in legal disputes. In jurisdictions like Europe, CA-provided signatures are often mandated. In India, the IT Act of 2000 recommends but doesn’t mandate them—this may change in the future.

Happy coding and let me know how it goes in the comments below.