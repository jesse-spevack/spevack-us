/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        border: 'var(--border)',
        input: 'var(--input)', 
        ring: 'var(--ring)',
        background: 'var(--background)',
        foreground: 'var(--foreground)',
        primary: {
          DEFAULT: 'var(--primary)',
          foreground: 'var(--primary-foreground)'
        },
        secondary: {
          DEFAULT: 'var(--secondary)',
          foreground: 'var(--secondary-foreground)'
        },
        accent: {
          DEFAULT: 'var(--accent)',
          foreground: 'var(--accent-foreground)'
        },
        card: {
          DEFAULT: 'var(--card)',
          foreground: 'var(--card-foreground)'
        },
        muted: {
          DEFAULT: 'var(--muted)',
          foreground: 'var(--muted-foreground)'
        },
        gradient: {
          'coral': '#FF7F7F',
          'orange': '#FFB366',
          'yellow': '#FFE066',
          'teal': '#66E0B3',
          'cyan': '#66D9EF',
          'blue': '#66B3FF',
          'purple': '#B366FF',
          'pink': '#FF66CC',
        },
        glass: {
          'white': 'rgba(255, 255, 255, 0.2)',
          'white-heavy': 'rgba(255, 255, 255, 0.9)',
          'backdrop': 'rgba(255, 255, 255, 0.1)',
        }
      },
      backgroundImage: {
        'gradient-rainbow': 'linear-gradient(135deg, #FF7F7F 0%, #FFB366 14%, #FFE066 28%, #66E0B3 42%, #66D9EF 57%, #66B3FF 71%, #B366FF 85%, #FF66CC 100%)',
        'gradient-coral-yellow': 'linear-gradient(135deg, #FF7F7F 0%, #FFE066 100%)',
        'gradient-teal': 'linear-gradient(135deg, #66E0B3 0%, #66D9EF 100%)',
        'gradient-coral': 'linear-gradient(135deg, #FF7F7F 0%, #FF66CC 100%)',
        'gradient-orange': 'linear-gradient(135deg, #FFB366 0%, #FFE066 100%)',
        'gradient-blue': 'linear-gradient(135deg, #66B3FF 0%, #B366FF 100%)',
        'gradient-purple': 'linear-gradient(135deg, #B366FF 0%, #FF66CC 100%)',
      },
      boxShadow: {
        'glass': '0 8px 32px 0 rgba(31, 38, 135, 0.37)',
        'task': '0 4px 16px 0 rgba(0, 0, 0, 0.1)',
        'floating': '0 12px 40px 0 rgba(0, 0, 0, 0.15)',
      },
      backdropBlur: {
        'glass': '8px',
      },
      borderRadius: {
        '2xl': '1rem',
        '3xl': '1.5rem',
        '4xl': '2rem',
      }
    }
  },
  plugins: []
}