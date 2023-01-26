var counter = 0
let observer = new MutationObserver(function(mutations) {
    var elements = document.getElementsByClassName('list-item');
    var elementsArray = Array.from(elements);
    var necessaryElements = elementsArray.slice(counter)
    necessaryElements.forEach((element) => {
        element.addEventListener('click', function() {
            getPostId(element);
        });
        counter = counter + 1
    })
});

observer.observe(document.body, {
    subtree: true,
    attributes: true
});

function getPostId(element) {
    window.webkit.messageHandlers.messenger.postMessage(element.getAttribute('data-ml-post-id'));
}
