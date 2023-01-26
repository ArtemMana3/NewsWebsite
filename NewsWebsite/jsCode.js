function getPostId(element) {
    window.webkit.messageHandlers.messenger.postMessage(element.getAttribute('data-ml-post-id'));
}

var counter = 0
let observer = new MutationObserver(function(mutations) {
    var elements = document.getElementsByClassName('list-item');
    var elementsArray = Array.from(elements);
    var necessaryElements = elementsArray.slice(counter)
    for (let item of necessaryElements) {
        item.addEventListener('click', function() {
            getPostId(item);
        });
        counter = counter + 1
    }
});

observer.observe(document.body, {
    subtree: true,
    attributes: true
});
