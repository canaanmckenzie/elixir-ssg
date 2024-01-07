document.addEventListener('DOMContentLoaded',  function() {
    //get the canvas element
    var canvas = document.getElementById('myCanvas');
    var ctx = canvas.getContext('2d');
    var t = 0;
    function draw(){
    //script1
        ctx.clearRect(0,0,canvas.width,canvas.height);
        ctx.width = 88;
        for (X = 8;X--;){
            for (Y=8;Y--;){
                var n = S(t/2*Y^X*t/2);
                ctx.fillRect(X,Y,n,n);
            }
        }
        for (i = 30; i--;){
            ctx.drawImage(canvas, i % 3 ? 8 : 0 , i % 2 ? 8 : 0);
        }
        t += 0.05;
        requestAnimationFrame(draw);
    }
    draw();
});

//define sinusoidal function
function S(x) {
    return Math.sin(x);
}
