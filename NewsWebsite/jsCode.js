var elementNumber = 0
let observer = new MutationObserver(function(mutations) {
    var elements = document.getElementsByClassName('list-item');
    var necessaryElements = Array.from(elements).slice(elementNumber)
    necessaryElements.forEach((element) => {
        element.addEventListener('click', function() {
            getPostId(element);
        });
        elementNumber = elementNumber + 1
    })
});

observer.observe(document.body, {
    subtree: true,
    attributes: true
});

function getPostId(element) {
    window.webkit.messageHandlers.messenger.postMessage(element.getAttribute('data-ml-post-id'));
}
