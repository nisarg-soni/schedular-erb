'use strict';

function parseRequestURL() {
	let url = location.hash.slice(1).toLowerCase() || '/';
	let r = url.split('/');
	let request = {
		resource: null,
		id: null,
		verb: null
	};
	request.resource = r[1];
	request.id = r[2];
	request.verb = r[3];
	return request;
}

let Navigationbar = `
<nav class="navbar navbar-expand-lg navbar-light bg-light">
  <a class="navbar-brand" href="#">Interview Scheduler</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
    <div class="navbar-nav">
      <a class="nav-item nav-link active" href="#/create">Create</a>
      <a class="nav-item nav-link active" href="#/update">Update</a>
      <a class="nav-item nav-link active" href="#/list">List</a>
    </div>
  </div>
</nav>
        `;

let Create = `
    <h1> Create Interview</h1>
    <div class="container">
        <form id="create-interview">
            <div class="form-group">
              <label for="date">Interview Date</label>
              <input type="date" name="date" class="form-control" id="date">
              
            </div>
            <div class="form-group">
                <label for="start">Start time</label>
                <input type="time" name="start" class="form-control" id="start">
            </div>
            <div class="form-group">
                <label for="end">End time</label>
                <input type="time" name="finish" class="form-control" id="finish">
            </div>
            <div class="form-group">
                <label for="topic">Topic</label>
                <input type="text" name="topic" class="form-control" id="topic">
            </div>
            <div class="form-group">
                <label for="interviewer">Interviewer Email</label>
                <input type="text" name="interviewer" class="form-control" id="interviewer">
            </div>
            <div class="form-group">
                <label for="candidate">Candidate Email</label>
                <input type="text" name="candidate" class="form-control" id="candidate">
            </div>
            <button type="submit" name="submit" class="btn btn-primary">Submit</button>
          </form>
    </div>
        `;

let Edit = `<div class="container">
<h1> Interview Details</h1>
<form id="update-interview">
    <div class="form-group">
        <label for="date">Interview Date</label>
        <input type="date" name="date" class="form-control" id="date">
      </div>
    <div class="form-group">
        <label for="start">Start time</label>
        <input type="time" name="start" class="form-control" id="start">
    </div>
    <div class="form-group">
        <label for="finish">End time</label>
        <input type="time" name="finish" class="form-control" id="finish">
    </div>
    <div class="form-group">
        <label for="topic">Topic</label>
        <input type="text" name="topic" class="form-control" id="topic">
    </div>
    <div class="form-group">
                <label for="interviewer">Interviewer Email</label>
                <input type="text" name="interviewer" class="form-control" id="interviewer">
            </div>
            <div class="form-group">
                <label for="candidate">Candidate Email</label>
                <input type="text" name="candidate" class="form-control" id="candidate">
            </div>
    <button type="submit" name="submit" class="btn btn-primary">Update</button>
</div>`;

let Home = `<div class="container">
<h1> Scheduled Interviews</h1> 
    <div id="content">
    </div>
</div>`;

let Delete = `
<p id="content">
 </p>
`;

const routes = {
	'/': Home,
	'/create': Create,
	'/delete/:id': Delete,
	'/edit/:id': Edit
};

function router() {
	const header = null || document.getElementById('header_container');
	const content = null || document.getElementById('page_container');

	header.innerHTML = Navigationbar;

	let request = parseRequestURL();

	let parsedURL =
		(request.resource ? '/' + request.resource : '/') +
		(request.id ? '/:id' : '') +
		(request.verb ? '/' + request.verb : '');

	let page = routes[parsedURL] ? routes[parsedURL] : Error404;

	content.innerHTML = page;

	if (page == Edit) {
		let date = document.querySelector('#date');
		let start = document.querySelector('#start');
		let end = document.querySelector('#finish');
		let title = document.querySelector('#topic');
		let interviewer = document.querySelector('#interviewer');
		let candidate = document.querySelector('#candidate');
		let edit = new XMLHttpRequest();
		edit.onreadystatechange = function() {
			if (this.readyState == 4 && this.status == 200) {
				var result = JSON.parse(this.responseText);

				date.value = result.date;
				var startTime = result.start;
				startTime = startTime.split(/[-:T]/);
				start.value = startTime[3] + ':' + startTime[4];
				var endTime = result.finish;
				endTime = endTime.split(/[-:T]/);
				end.value = endTime[3] + ':' + endTime[4];
				title.value = result.title;
				interviewer.value = result.interviewer.email;
				candidate.value = result.candidate.email;
			}
		};
		edit.open('GET', 'http://localhost:3000/api/v1/interviews/' + request.id);
		edit.send();
		function sendJSON() {
			edit.open('PUT', 'http://localhost:3000/api/v1/interviews/' + request.id);
			edit.setRequestHeader('Content-Type', 'application/json');
			edit.onreadystatechange = function() {
				if (edit.readyState === 4 && edit.status === 200) {
					var res = JSON.parse(this.responseText);
					if (res.status == 'ERROR-OVERLAP') {
						alert('There is an overlap in date and time');
					} else {
						alert('The Interview is created');
					}
				}
			};
			var data = JSON.stringify({
				date: date.value,
				start: start.value,
				finish: finish.value,
				topic: topic.value,
				interviewer: interviewer.value,
				candidate: candidate.value
			});
			edit.send(data);
		}
		let form = document.getElementById('update-interview');
		form.addEventListener('submit', function(event) {
			event.preventDefault();
			sendJSON();
		});
	} else if (page == Delete) {
		var deleteReq = new XMLHttpRequest();
		deleteReq.onload = function() {
			document.getElementById('content').innerHTML += 'Delete Successful';
		};
		deleteReq.open('DELETE', 'http://localhost:3000/api/v1/interviews/' + request.id);
		deleteReq.send(null);
	} else if (page == List) {
		var list = new XMLHttpRequest();
		list.onreadystatechange = function() {
			if (this.readyState == 4 && this.status == 200) {
				var p = JSON.parse(this.responseText);
				for (var i = 0; i < p.length; i++) {
					document.getElementById('content').innerHTML +=
						'<div class="alert alert-primary" role="alert">' +
						'<b>Date: </b>' +
						p[i].date +
						' ' +
						'<b>Start Time: </b>' +
						p[i].start +
						' ' +
						'<b>End Time: </b>' +
						p[i].finish +
						' ' +
						'<b>Topic: </b>' +
						p[i].topic +
						`<br>` +
						`<a href="#/delete/` +
						p[i].id +
						`" class="btn btn-danger">Delete</a><a href="#/edit/` +
						p[i].id +
						`" class="btn btn-success">Edit</a></div> `;
				}
			}
		};
		list.open('GET', 'http://localhost:3000/api/v1/interviews');
		list.send();
	} else if (page == Create) {
		function sendJSON() {
			let date = document.querySelector('#date');
			let start = document.querySelector('#start');
			let end = document.querySelector('#end');
			let title = document.querySelector('#title');
			let participants = document.querySelector('#participants');

			let request = new XMLHttpRequest();
			let url = 'http://localhost:3000/api/v1/interviews/';

			request.open('POST', url, true);

			request.setRequestHeader('Content-Type', 'application/json');

			request.onreadystatechange = function() {
				console.log(request.readyState);
				console.log(request.status);
				if (request.readyState === 4 && request.status === 200) {
					var res = JSON.parse(this.responseText);
					if (res.status == 'ERROR-OVERLAP') {
						alert('There is an overlap in date and time');
					} else {
						alert('The Interview is created');
					}
				}
			};

			var data = JSON.stringify({
				date: date.value,
				start: start.value,
				end: end.value,
				title: title.value,
				participantlist: participants.value
			});

			request.send(data);
		}
		let form = document.getElementById('create-interview');
		form.addEventListener('submit', function(event) {
			event.preventDefault();
			sendJSON();
		});
	}
}
window.addEventListener('hashchange', router);

window.addEventListener('load', router);
