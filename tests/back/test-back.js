function test(api) {
  if (api && api.handler && api.handler instanceof Function) {
    console.log('[√] PASS');
    process.exit(0);
  } else {
    console.log('[x] FAIL');
    process.exit(1);
  }
}

test({ handler: function () {} });
