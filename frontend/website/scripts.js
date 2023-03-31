(async function () {
  const apiBaseUrl =
    'https://v92mdkhrhd.execute-api.eu-west-1.amazonaws.com/api_stage_learning';

  const apiUrl = `${apiBaseUrl}/visits`;
  // const apiUrl = `https://api.gabtec.fun/api_stage_learning/visits`;

  // let vcounts = 1;
  const display = document.querySelector('#vcounter');
  // display.innerHTML = vcounts;

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
