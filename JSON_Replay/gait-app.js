const fileSelector = document.getElementById('file-selector');
const aButtons = document.getElementById("animationButtons");
const speedInput = document.getElementById("speedInput")
    // Les données du jon
let datas = [];

//json's keys
let keys = [];

//If a file has been selected or not
let selectedFile = false;

// Actual step of the animation
let stepIndex = 1;

// Step when the Stop button have been pressed
let stopIndex = 1;

let isAnimating = false;

// The animation Speed (the refresh every x milliseconds) seems to be caped
let animationSpeed = 30

// How many index will the animation skip between two steps
let indexJump = 1

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

speedInput.addEventListener("input", changeSpeed);

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
        //let domString = "\n"
        resultat.forEach(element => {
            var tabTmp = []
            for (const [key, value] of Object.entries(element)) {
                //console.log(`${key}: ${value}`);
                //domString += `${key}: ${value}` + "\n"
                tabTmp.push([key, value])
            }
            datas.push(tabTmp)
                //domString += "\n"
                /*
                domString += Object.entries(element) + "\n\n"
                */
        });
        //document.getElementById('monJson').innerText += domString
        setDatas()
        datas.reduce(setAllDatas, [])
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
    if (index >= datas.length) {
        stopAnimate()
        return
    }

    var joints = {
        x: [],
        y: [],
        z: [],
    }
    keys.forEach((key) => {
        if (!isNaN(getData(key, 0)[0])) {
            joints['x'].push(getData(key, index)[0])
            joints['z'].push(getData(key, index)[1])
            joints['y'].push(getData(key, index)[2])
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
    });
    return joints
}

function animation() {

}


function changeSpeed() {
    let speedValue = speedInput.value

    if (speedValue == "") {
        return
    }
    indexJump = Number(speedValue)
    if (isAnimating) {
        stopAnimate()
        resume()
    }
}


//launch the animation if not already, Change the second parameter
//of the setInterval function to change the speed animation
function animation() {
    if (!isAnimating) {
        interval = setInterval(increment, animationSpeed);
        isAnimating = true
    }
}

//Simple incrementation used in the setInterval function
function increment() {
    stepIndex += indexJump;
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


//load the next position of each points in the plot
function nextStep() {
    var joints = getDataStep(stepIndex)
    Plotly.animate('myDiv', {
        data: [{
            x: joints['x'],
            y: joints['y'],
            z: joints['z'],
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
        }],
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

/*
function f(previousValue, currentValue){
    return previousValue + currentValue
}
  
*/
//di = currentValue
//acc = acc
//i = currentIndex


function setAllDatas(previousValue, currentValue, index) {
    if (index % indexJump == 0) {}
}

function s() {
    datas.reduce((acc, di, index) => {
        if (index % indexJump == 0) {
            di.forEach((jk, k) => {
                ai += [jk]
            });
            acc.push([ai])
        }
    });
}

//initialise la vue plot avec les valeurs initiales du json
//La ligne avec body orientation sera surement retirer par la suite ou recevra un traitement spécial
function setDatas() {
    for (const [key] of datas[0]) {
        if (!isNaN(getData(key, 0)[0])) {
            keys.push(key)
        }
    }

    var joints = getDataStep(0)
    var data = {
        x: joints['x'],
        y: joints['y'],
        z: joints['z'],
        mode: 'markers',
        marker: {
            size: 12,
            line: {
                color: 'rgba(255, 217, 217, 0.14)',
                width: 0.5
            },
            opacity: 0.8
        },
        type: 'scatter3d'
    };
    console.log(data)
    var layout = {
        margin: {
            l: 0,
            r: 0,
            b: 0,
            t: 100,
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
            width: 1000,
        },
        autoexpand: false,
        title: {
            text: "jsonPlot",
            xanchor: "center"
        },
        width: 700,
        height: 500,
        autosize: false
    };
    Plotly.newPlot('myDiv', [data], layout);
}