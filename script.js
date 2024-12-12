let savedMovies = [];

function filterMovies() {
    // Logic to filter movies by genre
}

function addMovie(event) {
    event.preventDefault();
    const title = document.getElementById('movie-title').value;
    const genre = document.getElementById('movie-genre').value;
    const rating = parseFloat(document.getElementById('movie-rating').value);
    const description = document.getElementById('movie-description').value;
    savedMovies.push({ title, genre, rating, description });
    alert("Movie added successfully!");
    location.href = 'index.html';
}

function displayLibrary() {
    const libraryList = document.getElementById('library-list');
    libraryList.innerHTML = '';
    savedMovies.forEach(movie => {
        const movieDiv = document.createElement('div');
        movieDiv.className = 'movie-card';
        movieDiv.innerHTML = `
            <h3>${movie.title}</h3>
            <p><strong>Genre:</strong> ${movie.genre}</p>
            <p><strong>Rating:</strong> ${movie.rating}</p>
            <p>${movie.description}</p>
        `;
        libraryList.appendChild(movieDiv);
    });
	
	async function submitMovie(event) {
    event.preventDefault();
    const title = document.getElementById('movie-title').value;
    const genre = document.getElementById('movie-genre').value;
    const rating = parseFloat(document.getElementById('movie-rating').value);
    const description = document.getElementById('movie-description').value;

    const movieData = {
        title,
        genre,
        rating,
        description
    };

    try {
        const response = await fetch('http://localhost:8080/movies', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(movieData)
        });

        if (response.ok) {
            alert('Movie added successfully!');
            location.href = 'index.html';
        } else {
            const errorText = await response.text();
            alert(`Failed to add movie: ${errorText}`);
        }
    } catch (error) {
        alert(`Error: ${error.message}`);
    }
}

if (window.location.pathname.endsWith('library.html')) {
    displayLibrary();
}
