import "./style.css";
import * as THREE from "three";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import { DRACOLoader } from "three/examples/jsm/loaders/DRACOLoader";
import fragmentShader from "./shaders/fragment.glsl";
import vertexShader from "./shaders/vertex.glsl";
import { Clock } from "three";
import { GetSceneBounds } from "./utils";
import { OrbitControls } from "three/examples/jsm/Addons.js";

const { PI } = Math;

const canvas = document.querySelector("canvas");

canvas.width = innerWidth;
canvas.height = innerHeight;

const scene = new THREE.Scene();

const renderer = new THREE.WebGLRenderer({
  canvas,
  antialias: true,
  alpha: true,
});

const camera = new THREE.PerspectiveCamera(
  75,
  innerWidth / innerHeight,
  1,
  1000,
);
camera.position.z = 5 * 2;
camera.position.y = 3 * 2;

const controls = new OrbitControls(camera, canvas);

const Manager = new THREE.LoadingManager();
const Draco = new DRACOLoader(Manager);
const GLB = new GLTFLoader(Manager);
const TextureLoader = new THREE.TextureLoader(Manager);

Draco.setDecoderPath("/draco/");
Draco.setDecoderConfig({ type: "wasm" });
GLB.setDRACOLoader(Draco);

const PerlinTexture = TextureLoader.load('/textures/perlin.png');
PerlinTexture.wrapS = PerlinTexture.wrapT = THREE.RepeatWrapping;

const SmokeUniforms = {
  uTime: new THREE.Uniform(0),
  uPerlin: new THREE.Uniform(PerlinTexture),
}

const omlet = {

  // Omlet
  model: null,
  scale: 40,
  translation:[-1,-4,0],

  // Smoke
  smoke_position: new THREE.Vector3(),
  smoke_dims: [5/2,15],
  smoke: null,
  uniforms:SmokeUniforms,
  material: new THREE.ShaderMaterial({
    uniforms:SmokeUniforms,
    vertexShader,
    fragmentShader,
    transparent:true,
    side:THREE.DoubleSide,
    depthWrite:false
  })
};

// Loading The Omlet Model & Creating Omlet Smoke;
GLB.load("/model/omlet.glb", (glb) => {
  omlet.model = glb.scene;
  scene.add(omlet.model);

  glb.scene.traverse((n) => {
    if (n.isMesh && n.name == "Eggwhite_white_0") {
      omlet.smoke_position.copy(n.position).multiplyScalar(1);
    }
  });

  // Omlet Model Position
  omlet.model.position.set(...omlet.translation);
  omlet.model.scale.setScalar(omlet.scale);


  // Omlet Smoke
  omlet.smoke = new THREE.Mesh(
    new THREE.PlaneGeometry(omlet.smoke_dims[0], omlet.smoke_dims[1]),
    omlet.material,
  );
  omlet.smoke.geometry.translate(-1,omlet.smoke_dims[1]/2 - omlet.smoke_position.y / 2 + omlet.translation[1],0.3);
  omlet.smoke.position.copy(omlet.smoke_position)

  scene.add(omlet.smoke);
});


const clock = new Clock();
let PrevTime = clock.getElapsedTime();

function Animate() {
  const CurrentTime = clock.getElapsedTime();
  const DT = CurrentTime - PrevTime;
  PrevTime = CurrentTime;

  omlet.uniforms.uTime.value += DT;

  renderer.render(scene, camera);
  requestAnimationFrame(Animate);
}

requestAnimationFrame(Animate);

function resize() {
  camera.aspect = innerWidth / innerHeight;
  camera.updateProjectionMatrix();
  canvas.width = innerWidth;
  canvas.height = innerHeight;
  renderer.setSize(innerWidth, innerHeight);
}

window.addEventListener("resize", resize);
