---
title: Projects
layout: page
---

<div id="projects" >
<div class='block-btn'>
    <a class='btn fab fa-paypal' href='https://paypal.me/prahladyeri'>🅿️&nbsp;PayPal</a>
    <a class='btn fab fa-patreon' href='https://www.patreon.com/prahladyeri'>❤️&nbsp;Patreon</a>
</div>

<span class="fa-spin">Loading...</span>

<style>
#theTable {
    font-family: "cascadia code", consolas, monospace;
}
</style>

<table id="theTable" class="table table-striped table-sm table-bordered mt-3">
	<thead>
		<tr>
			<th scope="col">Project Name</th>
			<th scope="col">Description</th>
			<th scope="col">Stars</th>
			<th scope="col">Last Commit</th>
		</tr>
	</thead>
	<tbody id="projects-body">
		<!-- Dynamic content will be injected here -->
	</tbody>
</table>
</div>
<script type='module'>
document.addEventListener('DOMContentLoaded', function() {
	let apiUrl = "https://prahladyeri.github.io/uploads/projects.json";

    fetch(apiUrl)
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        let projects = '';
        data.items.forEach(repo => {
			projects += `
				<tr>
					<td><a href="${repo.html_url}" target="_blank">${repo.name}</a></td>
					<td>${repo.description || 'No description available'}</td>
					<td>${repo.stargazers_count}</td>
					<td>${new Date(repo.pushed_at).toLocaleDateString()}</td>
				</tr>
			`;
        });
		//<td><a href="${repo.html_url}" class="btn btn-dark text-light" target="_blank">View Project</a></td>
		
        document.getElementById("projects-body").innerHTML = projects;
        document.querySelector(".fa-spin").remove();        
    })
    .catch(error => {
        console.error('Error fetching data:', error);
        document.getElementById("projects-body").innerHTML = '<tr><td colspan="5" class="text-center text-danger">Error fetching data from GitHub</td></tr>';
        document.querySelector(".fa-spin").remove();
    });
});
</script>
