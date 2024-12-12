
// افزودن فیلم جدید
function addMovie() {
    const title = document.getElementById('title').value;
    const genre = document.getElementById('genre').value;
    const rating = parseFloat(document.getElementById('rating').value);

    if (!title || !genre || isNaN(rating)) {
        alert('لطفاً تمامی فیلدها را پر کنید.');
        return;
    }

    fetch('http://localhost:8080/movies', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ title, genre, rating })
    })
        .then(response => response.text())
        .then(data => {
            document.getElementById('addResult').innerText = 'فیلم با موفقیت اضافه شد: ' + data;
        })
        .catch(error => {
            document.getElementById('addResult').innerText = 'خطا در افزودن فیلم: ' + error;
        });
}

// // حذف فیلم
// function deleteMovie() {
//     const id = parseInt(document.getElementById('deleteId').value);

//     if (isNaN(id)) {
//         alert('لطفاً یک ID معتبر وارد کنید.');
//         return;
//     }

//     fetch(`http://localhost:8080/movies/${id}`, {
//         method: 'DELETE',
//     })
//     .then(response => {
//         if (!response.ok) {
//             return Promise.reject('خطا در حذف فیلم');
//         }
//         return response.text();
//     })
//     .then(data => {
//         document.getElementById('deleteResult').innerText = 'فیلم با موفقیت حذف شد: ' + data;
//     })
//     .catch(error => {
//         document.getElementById('deleteResult').innerText = 'خطا در حذف فیلم: ' + error;
//     });

// }

// نمایش فیلم‌ها
function fetchMovies() {
    fetch('http://localhost:8080/movies', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        },
    })
        .then(response => response.json())
        .then(data => {
            const movieListContainer = document.getElementById('movieList');
            movieListContainer.innerHTML = ''; // پاک کردن محتویات قبلی

            if (data.length == 0) {
                movieListContainer.innerHTML = 'هیچ فیلمی در پایگاه داده موجود نیست.';
            } else {

                data.forEach(movie => {
                    //داخل divرو ادیت کن
                    movieListContainer.insertAdjacentHTML('beforeend', `

                    
                    <div style="display: inline-block;text-align: center;"><li style="text-align: center; width: 190;margin-left:8px;margin-right:20px;background-color: #3e3e3e;border-radius: 10px;box-shadow: 0px 0px 10px 1px blue; list-style:none;padding:10px;margin-top:20px;" ><a href="http://127.0.0.1:5500/movie.html?id=${movie.id}" style="text-decoration:none; color: white;"><img src="https://picsum.photos/150/120" alt="${movie.title}" style="border-radius: 10px;">
<br>ID: ${movie.id} <br> عنوان: ${movie.title} <br> ژانر: ${movie.genre} <br> امتیاز: ${movie.rating}</a></li></div>
                    
                    `)

                });
                


                // movieListContainer.innerHTML = movieListHtml;
            }


        })
        .catch(error => {
            document.getElementById('movieList').innerText = 'خطا در دریافت فیلم‌ها: ' + error;
        });
}

function gotopage(){
    window.location.href = "test.html";
}



setTimeout(() => {

    document.addEventListener('load', fetchMovies())
}, 0);

let currentIndex = 0;

function moveSlide() {
  const slides = document.querySelectorAll('.slide');
  const totalSlides = slides.length;

  // برو به اسلاید بعدی
  currentIndex = (currentIndex + 1) % totalSlides;

  // جابجا کردن اسلایدر
  const slider = document.querySelector('.slider');
  slider.style.transform = `translateX(-${currentIndex * 100}%)`;
}

// تنظیم یک تایمر برای اسلاید خودکار
setInterval(moveSlide, 3000);  // 3000 میلی‌ثانیه (3 ثانیه)