const fileSelector = document.getElementById('file-selector');
// Les données du jon
let datas = [];
// les joints provenant du json sous forme de tableau associatif
let joints = {};

let stepIndex = 1;

let xMin,
    yMin,
    zMin;
let xMax,
    yMax,
    zMax;

let interval;

fileSelector.addEventListener('change', (event) => {
    const fileList = event.target.files;
    console.log(fileList);
    console.log(fileList[0])
    const reader = new FileReader();
    reader.addEventListener('load', (event) => {
        let resultat = event.target.result
        resultat = JSON.parse(resultat)
        let i = 0;
        //console.log(resultat.length)
        let domString = "\n"
        resultat.forEach(element => {
            var tabTmp = []
            for (const [key, value] of Object.entries(element)) {
                //console.log(`${key}: ${value}`);
                //console.log(i++)
                domString += `${key}: ${value}` + "\n"
                tabTmp.push([key, value])
            }
            //console.log(tabTmp)
            datas.push(tabTmp)
            domString += "\n"
                /*
                console.log(i++)
                domString += Object.entries(element) + "\n\n"
                */
        });
        document.getElementById('monJson').innerText += domString
            //console.log(resultat[0])
            //console.log(datas)
        setDatas()
    });
    reader.readAsText(fileList[0])

    //readImage(fileList[0])
});

/*
function readImage(file) {
    // Check if the file is an image.
    if (file.type && !file.type.startsWith('image/')) {
        console.log('File is not an image.', file.type, file);
        return;
    }

    const reader = new FileReader();
    reader.addEventListener('load', (event) => {
        img.src = event.target.result;
    });
    reader.readAsText(file);
    console.log(reader.result)
}
*/

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

//var myPlot = Plotly.newPlot

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
    console.log(datas.length)
    if (index >= datas.length) {
        clearInterval(interval)
        stepIndex = 1
        return
    }
    for (const key in joints) {
        if (!isNaN(getData(key, 0)[0])) {
            joints[key]['x'] = [getData(key, index)[0]]
            joints[key]['y'] = [getData(key, index)[1]]
            joints[key]['z'] = [getData(key, index)[2]]
                //console.log(joints[key]['x'])
                //console.log(getData(key, index)[0])
            if (index == 0 && !isNaN(xMax)) {
                xMin = Math.min(getData(key, index)[0], xMin)
                yMin = Math.min(getData(key, index)[1], yMin)
                zMin = Math.min(getData(key, index)[2], zMin)
                xMax = Math.max(getData(key, index)[0], xMax)
                yMax = Math.max(getData(key, index)[1], yMax)
                zMax = Math.max(getData(key, index)[2], zMax)
            } else if (isNaN(xMax)) {
                xMin = getData(key, index)[0]
                yMin = getData(key, index)[1]
                zMin = getData(key, index)[2]
                xMax = getData(key, index)[0]
                yMax = getData(key, index)[1]
                zMax = getData(key, index)[2]
            }
        }
    }

    console.log("xMin:", xMin)
    console.log("yMin:", yMin)
    console.log("zMin:", zMin)
    console.log("xMax:", xMax)
    console.log("yMax:", yMax)
    console.log("zMax:", zMax)

    var data = [];
    for (const key in joints) {
        data.push(joints[key])
            //console.log(joints[key])
    }
    return data
}

function animation() {
    interval = setInterval(increment, 1000 / 60);
}

function increment() {
    stepIndex++;
    console.log(stepIndex)
    nextStep()
}

function nextStep() {
    Plotly.animate('myDiv', {
        data: getDataStep(stepIndex),
        traces: [0],
        layout: {}
    }, {
        transition: {
            duration: 60,
            easing: 'linear'
        },
        frame: {
            duration: 60
        }
    })
}

//initialise la vue plot avec les valeurs initiales du json
//La ligne avec body orientation sera surement retirer par la suite ou recevra un traitement spécial
function setDatas() {
    for (const [key] of datas[0]) {
        joints[key] = createDico(0)
    }

    var data = getDataStep(0)
    console.log(data)
    var layout = {
        margin: {
            l: 50,
            r: 50,
            b: 100,
            t: 100,
        },
        scene: {
            xaxis: {
                range: [xMin - 1, xMax + 1],
            },
            yaxis: {
                range: [yMin - 1, yMax + 1],
            },
            zaxis: {
                range: [zMin - 1, zMax + 1],
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
        width: 700,
        height: 700,
        autosize: false
    };
    Plotly.newPlot('myDiv', data, layout);
}