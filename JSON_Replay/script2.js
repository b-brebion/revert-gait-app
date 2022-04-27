const fileSelector = document.getElementById('file-selector');
const aButtons = document.getElementById("animationButtons");
// Les données du jon
let datas = [];
// les joints provenant du json sous forme de tableau associatif
let joints = {};

//If a file has been selected or not
let selectedFile = false;

// Actual step of the animation
let stepIndex = 1;

// Step when the Stop button have been pressed
let stopIndex = 1;

let isAnimating = false;

// The animation Speed (the refresh every x milliseconds) seems to be caped
let animationSpeed = 30

//Values used to correctly scale the plot layout
let xMin,
    yMin,
    zMin;
let xMax,
    yMax,
    zMax;

// Declare of the interval variable wich allows to display things over time
let interval;

aButtons.style.display = "none";
console.log(aButtons.style.display)

fileSelector.addEventListener('change', (event) => {
    //Display animation's Buttons
    aButtons.style.display = "block";

    const fileList = event.target.files;
    console.log(fileList);
    console.log(fileList[0])
    const reader = new FileReader();
    reader.addEventListener('load', (event) => {
        let resultat = event.target.result
        resultat = JSON.parse(resultat)
        let i = 0;
        //console.log(resultat.length)
        //let domString = "\n"
        resultat.forEach(element => {
            var tabTmp = []
            for (const [key, value] of Object.entries(element)) {
                //console.log(`${key}: ${value}`);
                //console.log(i++)
                //domString += `${key}: ${value}` + "\n"
                tabTmp.push([key, value])
            }
            //console.log(tabTmp)
            datas.push(tabTmp)
                //domString += "\n"
                /*
                console.log(i++)
                domString += Object.entries(element) + "\n\n"
                */
        });
        //document.getElementById('monJson').innerText += domString
        //console.log(resultat[0])
        //console.log(datas)
        setDatas()
    });
    reader.readAsText(fileList[0])

    //readImage(fileList[0])
});

function createDico(i) {
    return {
        x: [i],
        y: [i],
        z: [i],
        mode: 'markers',
        marker: {
            size: 12,
            line: {
                color: 'rgba(217, 217, 217, 0.14)',
                width: 0.5
            },
            opacity: 0.8
        },
        type: 'scatter3d'
    };
}

//renvoie les données correspondant à la cle et à l'index donnée en parametres
//sous la forme d'un tableau de float à 3 dimensions
function getData(key, index) {
    var retour = ''
    datas[index].forEach((elt) => {
        //console.log(elt)
        if (elt[0] == key) {
            retour = elt[1]
        }
    });
    myData = retour.split('(')
    myData = myData[1].split(')')
    retour = myData[0]
    myData = retour.split(',')

    return myData.map(function(elt) {
        return parseFloat(elt)
    })
}

//return le tableau de donnée correspondant à l'étape donné en paramètre
function getDataStep(index) {
    //console.log(datas.length)
    if (index >= datas.length) {
        stopAnimate()
        return
    }
    for (const key in joints) {
        if (!isNaN(getData(key, 0)[0])) {
            joints[key]['x'] = [getData(key, index)[0]]
            joints[key]['z'] = [getData(key, index)[1]]
            joints[key]['y'] = [getData(key, index)[2]]
                //console.log(joints[key]['x'])
                //console.log(getData(key, index)[0])
            if (index == 0 && !isNaN(xMax)) {
                xMin = Math.min(getData(key, index)[0], xMin)
                yMin = Math.min(getData(key, index)[2], yMin)
                zMin = Math.min(getData(key, index)[1], zMin)
                xMax = Math.max(getData(key, index)[0], xMax)
                yMax = Math.max(getData(key, index)[2], yMax)
                zMax = Math.max(getData(key, index)[1], zMax)
            } else if (isNaN(xMax)) {
                xMin = getData(key, index)[0]
                yMin = getData(key, index)[2]
                zMin = getData(key, index)[1]
                xMax = getData(key, index)[0]
                yMax = getData(key, index)[2]
                zMax = getData(key, index)[1]
            }
        }
    }

    /*
    console.log("xMin:", xMin)
    console.log("yMin:", yMin)
    console.log("zMin:", zMin)
    console.log("xMax:", xMax)
    console.log("yMax:", yMax)
    console.log("zMax:", zMax)
    */

    var data = [];
    for (const key in joints) {
        data.push(joints[key])
            //console.log(joints[key])
    }
    return data
}

//launch the animation if not already, Change the second parameter
//of the setInterval function to change the speed animation
function animation() {
    console.log(animationSpeed)
    if (!isAnimating) {
        interval = setInterval(increment, animationSpeed);
        isAnimating = true
    }
}

//Simple incrementation used in the setInterval function
function increment() {
    stepIndex++;
    console.log(stepIndex)
    nextStep()
}

// make the animation resume where it has been stopped
function resume() {
    if (!isAnimating) {
        stepIndex = stopIndex
        animation()
    }
}

//stop the animation
function stopAnimate() {
    if (isAnimating) {
        clearInterval(interval)
        stopIndex = stepIndex
        stepIndex = 1
        isAnimating = false
    }
}

/*
function defSpeed(value = 0, mySpeed = 16) {
    stopAnimate();
    switch (value) {
        case 0:
            animationSpeed = 16;
            break;
        case 1:
            animationSpeed = 8;
            break;
        case 2:
            animationSpeed = 5.33;
            break;
        case 3:
            animationSpeed = mySpeed
            break;
    }
    resume();
}
*/

//load the next position of each points in the plot
function nextStep() {
    Plotly.animate('myDiv', {
        data: getDataStep(stepIndex),
        traces: [0],
        layout: {}
    }, {
        transition: {
            duration: animationSpeed,
            easing: 'linear'
        },
        frame: {
            duration: animationSpeed,
        }
    })
}

//initialise la vue plot avec les valeurs initiales du json
//La ligne avec body orientation sera surement retirer par la suite ou recevra un traitement spécial
function setDatas() {
    for (const [key] of datas[0]) {
        if (key != 'bodyOrientation') {
            joints[key] = createDico(0)
        }
    }

    var data = getDataStep(0)
    console.log(data)
    var layout = {
        margin: {
            l: 0,
            r: 0,
            b: 0,
            t: 0,
        },
        scene: {
            xaxis: {
                range: [xMin - 3, xMax + 3],
            },
            yaxis: {
                range: [yMin - 3, yMax + 3],
            },
            zaxis: {
                range: [zMin - 0.5, zMax + 0.5],
            },
            aspectratio: {
                x: 1,
                y: 1,
                z: 1
            },
        },
        autoexpand: false,
        title: {
            text: "jsonPlot",
            xanchor: "center"
        },
        width: 1200,
        height: 700,
        autosize: false
    };
    Plotly.newPlot('myDiv', data, layout);
}