function openModal(id) {
  const modal = document.getElementById(id);
  if (modal) {
    modal.style.display = 'flex';
    // 背景スクロールを止める（任意）
    document.body.style.overflow = 'hidden';
  }
}

function closeModal(id) {
  const modal = document.getElementById(id);
  if (modal) {
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
  }
}

window.addEventListener('click', (event) => {
  if (event.target.classList.contains('custom-modal-overlay')) {
    const modalId = event.target.id;
    closeModal(modalId);
  }
});

// RailsのTurbo対策としてwindowオブジェクトに登録
window.openModal = openModal;
window.closeModal = closeModal;
