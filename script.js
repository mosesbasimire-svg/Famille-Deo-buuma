// ================= MODIFICATIONS FACILES =================
const PASSWORD = "DEO";
const WHATSAPP_LINK = "COLLEZ-ICI-LE-LIEN-DU-GROUPE";
// ==========================================================

const members = [
["Déo Vumilia Buuma","Père","26/12/1972","Père de la famille, gradué en sciences de l'éducation et enseignant dans une école secondaire."],
["Sirire Masirika Francine","Mère","01/03/1978","Mère de la famille, commerçante et cultivatrice."],
["Ameshinda Vumilia Alliance","Fils aîné — décédé","03/11/1996","Fils aîné de la famille. Il est décédé célibataire, après avoir atteint le niveau de Bac 2 en management. Que son âme repose en paix."],
["Salama Namwangasa Yvette","2e enfant — fille","14/07/2000","Infirmière, graduée de l'Institut Supérieur des Techniques Médicales de Bukavu. Elle est mariée à Justin Ushindi."],
["Buuma Vumilia Benjamin","3e fils","10/05/2002","Laborantin, licencié en laboratoire de l'Institut Supérieur des Techniques Médicales de Bukavu."],
["ATUKUZWE Vumilia Jonathan","4e fils","22/05/2005","Informaticien, licencié de l'Institut Supérieur Pédagogique de Bukavu."],
["Basimire Vumilia Moïse","5e fils","18/09/2007","Économiste, licencié de l'Université Officielle de Bukavu."],
["Barikiwa Vumilia Angélique","6e fille","20/03/2010","Commercialiste de l'Institut Kando."],
["Bwaashi Vumilia Gloire","7e fils","16/09/2012","Commercialiste de l'Institut Kando."],
["Chisiki Vumilia Bien-aimé","8e fils","16/10/2014","Histoire à compléter…"],
["Furaha Vumilia Noela","9e fille","26/12/2016","Histoire à compléter…"],
["Asifiwe Vumilia Victoire","10e enfant — fils, cadet","07/07/2018","Cadet de la famille."]
];

const esc=s=>String(s).replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#039;"}[c]));
const key=i=>"member-photo-"+i;

function login(){
 if(document.getElementById("password").value!==PASSWORD){
   document.getElementById("error").style.display="block"; return;
 }
 document.getElementById("login").style.display="none";
 document.getElementById("site").style.display="block";
 document.getElementById("logout").style.display="block";
 render();
 document.getElementById("welcome").style.display="grid";
}
function render(){
 document.getElementById("members").innerHTML=members.map((m,i)=>{
   const p=localStorage.getItem(key(i));
   return `<article class="member">
   ${p?`<img class="member-photo" src="${p}" alt="Photo">`:`<div class="member-photo">👤</div>`}
   <h3>${esc(m[0])}</h3><b>${esc(m[1])}</b> — ${esc(m[2])}<p>${esc(m[3])}</p>
   <div class="actions">
    <input id="file-${i}" type="file" accept="image/*" hidden>
    <button class="small" onclick="document.getElementById('file-${i}').click()">📷 Ajouter / changer</button>
    ${p?`<button class="small delete" onclick="removeMemberPhoto(${i})">🗑️ Supprimer</button>`:""}
   </div></article>`;
 }).join("");
 members.forEach((_,i)=>document.getElementById("file-"+i).addEventListener("change",e=>saveMemberPhoto(i,e.target.files[0])));
 renderGallery();
 const w=document.getElementById("whatsapp");
 if(WHATSAPP_LINK.startsWith("https://"))w.href=WHATSAPP_LINK;
 else w.onclick=e=>{e.preventDefault();alert("Ajoutez le lien WhatsApp en haut de script.js.");};
}
function saveMemberPhoto(i,file){
 if(!file)return;
 const r=new FileReader();
 r.onload=e=>{try{localStorage.setItem(key(i),e.target.result);render()}catch(err){alert("Image trop lourde. Choisissez une image plus petite.")}};
 r.readAsDataURL(file);
}
function removeMemberPhoto(i){localStorage.removeItem(key(i));render()}
function renderGallery(){
 const a=JSON.parse(localStorage.getItem("family-gallery")||"[]");
 document.getElementById("gallery").innerHTML=a.map((p,i)=>`<figure><img src="${p.data}" alt="Souvenir"><button onclick="removeGallery(${i})">×</button><figcaption>${esc(p.caption||"Souvenir de famille")}</figcaption></figure>`).join("");
}
function addPhotos(){
 const files=[...document.getElementById("photosInput").files];
 if(!files.length){alert("Choisissez une photo.");return}
 const caption=document.getElementById("caption").value;
 const a=JSON.parse(localStorage.getItem("family-gallery")||"[]");
 let left=files.length;
 files.forEach(f=>{const r=new FileReader();r.onload=e=>{a.push({data:e.target.result,caption});if(--left===0){try{localStorage.setItem("family-gallery",JSON.stringify(a));renderGallery()}catch(err){alert("Stockage insuffisant : utilisez des images plus petites.")}}};r.readAsDataURL(f)});
}
function removeGallery(i){const a=JSON.parse(localStorage.getItem("family-gallery")||"[]");a.splice(i,1);localStorage.setItem("family-gallery",JSON.stringify(a));renderGallery()}

document.getElementById("enter").onclick=login;
document.getElementById("password").onkeydown=e=>{if(e.key==="Enter")login()};
document.getElementById("closeWelcome").onclick=()=>document.getElementById("welcome").style.display="none";
document.getElementById("logout").onclick=()=>location.reload();
document.getElementById("addPhotos").onclick=addPhotos;
