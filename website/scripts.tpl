(async function () {
  const apiUrl = `${apiBaseUrl}/visits`;

  const display = document.querySelector('#vcounter');

  // read stored counter
  fetch(apiUrl)
    .then((res) => res.json())
    .then((data) => {
      vcounts = data.visitsCount + 1;
      display.innerHTML = vcounts;
      // store new counter
      return fetch(apiUrl, {
        method: 'PUT',
        mode: 'cors',
        // headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ count: vcounts }),
      });
    })
    .catch((err) => {
      console.log(err);
    });
})();
