function moveClass(){
  let items = document.getElementsByClassName('nav-link');
  let path_name = window.location.pathname

  if ("/" == path_name) {
    items[0].classList.add("active")    // <- /
    items[1].classList.remove("active") // <- /blog
    items[2].classList.remove("active") // <- /contact
    items[3].classList.remove("active") // <- /about
    items[4].classList.remove("active") // <- /about
  } else if ("/contact" == path_name) {
    items[0].classList.remove("active")
    items[1].classList.remove("active")
    items[2].classList.add("active")
    items[3].classList.remove("active")
    items[4].classList.remove("active")
  } else if ("/about" == path_name) {
    items[0].classList.remove("active")
    items[1].classList.remove("active")
    items[2].classList.remove("active")
    items[3].classList.add("active")
    items[4].classList.remove("active")
  } else if ("/road-to-sre" == path_name) {
    items[0].classList.remove("active")
    items[1].classList.remove("active")
    items[2].classList.remove("active")
    items[3].classList.remove("active")
    items[4].classList.add("active")
  } else {
    items[0].classList.remove("active")
    items[1].classList.add("active")
    items[2].classList.remove("active")
    items[3].classList.remove("active")
    items[4].classList.remove("active")
  }
}

document.addEventListener('DOMContentLoaded', moveClass)
