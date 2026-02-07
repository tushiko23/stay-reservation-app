  // 画像のアップロード時にファイル名を表示

document.addEventListener('turbo:load', () => {
  const inputs = document.querySelectorAll('.js-file-input');

  inputs.forEach(input => {
    const targetName = input.dataset.filenameTarget;
    const fileNameEl = document.querySelector(
      `.file-name[data-filename="${targetName}"]`
    );

    if (!fileNameEl) return;

    input.addEventListener('change', () => {

      fileNameEl.textContent =
        input.files.length > 0
          ? input.files[0].name
          : '選択されていません';

      const name = input.files[0].name;

      fileNameEl.textContent =
        name.length > 10
          ? `${name.slice(0, 10)}...`
          : name;
    });
  });
});

