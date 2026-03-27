const CACHE_NAME = 'lost-trails-v1';
const urlsToCache = [
  './',
  './index.html',
  './lost-trails.js',
  './lost-trails.wasm',
  './lost-trails.pck',
  './lost-trails.png',
  './lost-trails.icon.png',
  './lost-trails.apple-touch-icon.png',
  './lost-trails.audio.worklet.js',
  './lost-trails.audio.position.worklet.js'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
      .catch(() => {
        // Return offline page if offline
        return caches.match('./index.html');
      })
  );
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});
