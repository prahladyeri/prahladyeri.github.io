---
title: Projects
layout: page
---

<div id="projects" >
<div class='block-btn'>
    <a class='btn fab fa-paypal' href='https://paypal.me/prahladyeri'>&nbsp;PayPal</a>
    <a class='btn fab fa-patreon' href='https://www.patreon.com/prahladyeri'>&nbsp;Patreon</a>
</div>

<span class="fa-spin">Loading...</span>
</div>
<div class='project-item d-none text-muted'>
	Project: <a href="javascript:" class='name'></a><br>
	Description: <label class='description'></label><br>
	Stars: <label class='stars fas fa-star'></label><br>
	Last commit: <label class='pushed_at'></label><br>
</div>

<script type='module'>
document.addEventListener('DOMContentLoaded', function(){
	console.log('calling event handler:');
	var url = "/uploads/projects.json?" + (+new Date());
	//const response = await fetch(url);
	//const data=  await response.json();

	fetch(url)
	.then(response => response.json())
	.then(data => {
		console.log('fetch worked:', data);
		for(var i=0;i<data.length;i++) {
			var item = document.querySelector('.project-item.d-none').cloneNode(true);
			
			//item.removeClass('d-none');
			item.className = item.className.replace(/\bd-none\b/, "");
			item.querySelector(".name").innerHTML= data[i].name;
			item.querySelector(".name").attributes.href.value= data[i].html_url;
			item.querySelector(".pushed_at").innerHTML = data[i].pushed_at;
			item.querySelector(".description").innerHTML = data[i].description;
			item.querySelector('.stars').innerHTML = " " + data[i].stars;

			document.querySelector("#projects").appendChild(item);
		}
		document.querySelector(".fa-spin").remove();		
	})
});
	
</script>
