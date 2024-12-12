console.log("hello world !!!!");


let getIdUrl = new URLSearchParams(location.search);

let idMovie = getIdUrl.get("id")

const textBody = document.querySelector('.textBody')
// textBody.innerHTML = idMovie

window.addEventListener('load', () => {
    fetch('http://localhost:8080/movies', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    })
        .then(response => response.json())
        .then(data => {
            let dataById = data.filter((movie) => movie.id == idMovie)

            // console.log(dataById[0]);

            let movie = dataById[0]


            textBody.insertAdjacentHTML('beforeend', `
                ID: ${movie.id} | عنوان: ${movie.title} | ژانر: ${movie.genre} | امتیاز: ${movie.rating}
                `)

            

        })
})