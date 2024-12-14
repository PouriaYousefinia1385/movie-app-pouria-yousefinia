function fetchMovies() {
    fetch('http://localhost:8080/movies', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
    })
        .then(response => response.json())
        .then(data => {
            const movieListContainer = document.getElementById('movieList');
            movieListContainer.innerHTML = '';

            if (data.length === 0) {
                movieListContainer.innerHTML = 'No movies available.';
            } else {
                data.forEach(movie => {
                    movieListContainer.insertAdjacentHTML('beforeend', `
                        <div style="display: inline-block;text-align: center;">
                            <li style="text-align: center; width: 190;margin: 8px;background-color: #3e3e3e;
                                border-radius: 10px;box-shadow: 0px 0px 10px 1px blue; list-style:none;
                                padding:10px;">
                                <a href="movie.html?id=${movie.id}" style="text-decoration:none; color: white;">
                                    <img src="https://picsum.photos/150/120" alt="${movie.title}" style="border-radius: 10px;">
                                    <br>ID: ${movie.id}<br>Title: ${movie.title}<br>Genre: ${movie.genre}<br>Rating: ${movie.rating}
                                </a>
                            </li>
                        </div>
                    `);
                });
            }
        })
        .catch(error => {
            document.getElementById('movieList').innerText = 'Error fetching movies: ' + error;
        });
}

document.addEventListener('DOMContentLoaded', fetchMovies);
