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
      },
   },
};
