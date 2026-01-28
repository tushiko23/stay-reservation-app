  // プロフィールのアイコンアップロード時にファイル名を表示

  document.addEventListener('DOMContentLoaded', () => {
    const input = document.getElementById('profile_icon');
    const fileName = document.querySelector('.file-name');

    if (!input || !fileName) return;

    input.addEventListener('change', () => {
      if (input.files.length > 0) {
        fileName.textContent = input.files[0].name;
      } else {
        fileName.textContent = '選択されていません';
      }
    });
  });

