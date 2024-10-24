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

<table class="table table-striped table-sm table-bordered mt-3">
	<thead>
		<tr>
			<th scope="col">Project Name</th>
			<th scope="col">Description</th>
			<th scope="col">Stars</th>
			<th scope="col">Last Commit</th>
			<th scope="col">Link</th>
		</tr>
	</thead>
	<tbody id="projects-body">
		<!-- Dynamic content will be injected here -->
	</tbody>
</table>
</div>
<!-- <div class='project-item d-none text-muted'> -->
	<!-- Project: <a href="javascript:" class='name'></a><br> -->
	<!-- Description: <label class='description'></label><br> -->
	<!-- Stars: <label class='stars fas fa-star'></label><br> -->
	<!-- Last commit: <label class='pushed_at'></label><br> -->
<!-- </div> -->

<script type='module'>
document.addEventListener('DOMContentLoaded', function() {
    const username = 'prahladyeri'; // Replace with your GitHub username
    const apiUrl = `https://api.github.com/users/${username}/repos`;

    fetch(apiUrl)
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        console.log('fetch worked:', data);
        let projects = '';
        for (var i = 0; i < data.length; i++) {
            // Only include public repos that are not forks
            if (!data[i].fork && data[i].private === false) {
                projects += `
                    <tr>
                        <td><a href="${data[i].html_url}" target="_blank">${data[i].name}</a></td>
                        <td>${data[i].description || 'No description available'}</td>
                        <td>${data[i].stargazers_count}</td>
                        <td>${new Date(data[i].pushed_at).toLocaleDateString()}</td>
                        <td><a href="${data[i].html_url}" class="btn btn-dark text-light" target="_blank">View Project</a></td>
                    </tr>
                `;
            }
        }
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
