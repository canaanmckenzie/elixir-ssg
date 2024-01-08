module.exports = {
    content: [
        "./**/*.js",
        "../lib/quant_notes.ex",
    ],

    plugins: [
        require("@tailwindcss/typography"),
    ],

  theme: {
      colors: {
          'sumiblack' : '#101416',
          'pearl': '#dfe3e6',
          'neonblue': '#01F9C6',
          'gray': '#808080',
          'white': '#FBFAF5',
          'tyrianPurple':'#66023C',
          'tekheletBlue':'#075299 ',
      },
   },
};
