function moveClass(){
  let items = document.getElementsByClassName('nav-link');
  let path_name = window.location.pathname

  if ("/" == path_name) {
    items[0].classList.add("active")    // <- /
    items[1].classList.remove("active") // <- /blog
    items[2].classList.remove("active") // <- /about
  } else if ("/blog" == path_name) {
    items[0].classList.remove("active")
    items[1].classList.add("active")
    items[2].classList.remove("active")
  } else {
    items[0].classList.remove("active")
    items[1].classList.remove("active")
    items[2].classList.add("active")
  }
}

document.addEventListener('DOMContentLoaded', moveClass)
