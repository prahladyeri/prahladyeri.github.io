---
title: Portfolio
layout: page
---

<div id="portfolio" >
<span class="fa-spin">Loading...</span>
</div>
<div class='portfolio-item d-none'>
	<h2 class='title'></h2>
	<!-- <label>Category:&nbsp;</label><label class='category'></label><br> -->
	<p class='description text-muted'></p>
	<img height='320' width='850' src=''>
	<br>
	<hr>
</div>
<script>

document.addEventListener('DOMContentLoaded', function(){
	console.log('calling event handler:');
	var url = "/uploads/portfolio.json?" + (+new Date());
	//const response = await fetch(url);
	//const data=  await response.json();

	fetch(url)
	.then(response => response.json())
	.then(data => {
		console.log('fetch worked:', data);
		for(var i=0;i<data.length;i++) {
			var item = document.querySelector('.portfolio-item.d-none').cloneNode(true);
			
			//item.removeClass('d-none');
			item.className = item.className.replace(/\bd-none\b/, "");
			var titleText = "";
			if (data[i].url !== "") {
				titleText = "<a target='_blank' href='" + data[i].url + "'>" + data[i].title + "</a>";
			}
			else {
				titleText = data[i].title;
			}
			item.querySelector(".title").innerHTML= titleText;
			item.querySelector("img").attributes.src.value = data[i].image_url;
			item.querySelector('.description').innerHTML = (data[i].text);

			document.querySelector("#portfolio").appendChild(item);
		}
		document.querySelector(".fa-spin").remove();		
	
	})
	

});
	
</script>
