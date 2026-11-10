// Menu mobile, apparition au défilement, année du pied de page, formulaire de contact (mailto).
(() => {
  const header = document.querySelector('.site-header');
  const toggle = document.querySelector('.menu-toggle');
  if (header && toggle) {
    toggle.addEventListener('click', () => {
      const open = header.classList.toggle('open');
      toggle.setAttribute('aria-expanded', String(open));
    });
    header.querySelectorAll('.nav-links a').forEach((a) => a.addEventListener('click', () => header.classList.remove('open')));
  }

  const items = document.querySelectorAll('.reveal');
  if ('IntersectionObserver' in window) {
    const io = new IntersectionObserver((entries) => {
      entries.forEach((e) => {
        if (e.isIntersecting) {
          e.target.classList.add('visible');
          io.unobserve(e.target);
        }
      });
    }, { threshold: 0.12 });
    items.forEach((el) => io.observe(el));
  } else {
    items.forEach((el) => el.classList.add('visible'));
  }

  document.querySelectorAll('[data-year]').forEach((el) => { el.textContent = String(new Date().getFullYear()); });

  const form = document.querySelector('#contact-form');
  if (form) {
    form.addEventListener('submit', (ev) => {
      ev.preventDefault();
      const d = new FormData(form);
      const subject = `${d.get('subject') || 'Contact'} — ${d.get('company') || d.get('name') || 'eFatoura'}`;
      const body = [
        `Nom : ${d.get('name') || ''}`,
        `Société / cabinet : ${d.get('company') || ''}`,
        `Téléphone : ${d.get('phone') || ''}`,
        `E-mail : ${d.get('email') || ''}`,
        '',
        String(d.get('message') || ''),
      ].join('\n');
      window.location.href = `mailto:contact@efatoura.ma?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;
    });
  }
})();
