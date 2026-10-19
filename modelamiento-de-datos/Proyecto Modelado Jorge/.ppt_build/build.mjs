import fs from 'node:fs/promises';
import path from 'node:path';
import {pathToFileURL} from 'node:url';
import {Presentation, PresentationFile} from '@oai/artifact-tool';

const root=path.resolve('Proyecto Modelado Jorge');
const tmp=path.join(root,'.ppt_build');
const skill='C:/Users/JORGE/.codex/plugins/cache/openai-primary-runtime/presentations/26.1007.11041/skills/presentations';
const p=Presentation.create({slideSize:{width:1280,height:720}});
const fontPolicy={basis:'design',families:['Arial']};
function text(s,t,x,y,w,h,size=24,color='#24374A',bold=false){
 const a=s.shapes.add({geometry:'textbox',position:{left:x,top:y,width:w,height:h},fill:'none',line:{fill:'none',width:0}});
 a.text=t;a.text.style={typeface:'Arial',fontSize:size,color,bold};return a;
}
function slide(title,n){const s=p.slides.add();s.background.fill='#FFFFFF';text(s,title,48,28,1160,65,42,'#103D52',true);text(s,`TherapyFlex    /    Proyecto de modelamiento de datos`,48,682,1100,22,15,'#617584');text(s,String(n).padStart(2,'0'),1190,680,45,25,17,'#117C87',true);return s;}
async function pic(s,rel,x,y,w,h){let b=await fs.readFile(path.join(root,rel));s.images.add({blob:b.buffer.slice(b.byteOffset,b.byteOffset+b.byteLength),contentType:'image/png',alt:rel,fit:'contain',position:{left:x,top:y,width:w,height:h}});}

let s=slide('Sistema de gestión de centro de salud',1);
text(s,'PROYECTO MODELAMIENTO DE DATOS',50,112,1150,34,22,'#117C87',true);
text(s,'TherapyFlex: gestión de pacientes y atención de fisioterapia',50,163,1150,75,34,'#103D52',true);
text(s,'Introducción y solución',50,283,365,42,26,'#117C87',true);
text(s,'Un modelo relacional organiza los registros del centro y vincula a cada paciente con su atención y sus registros económicos.',50,337,355,240,25);
text(s,'Problemática actual',457,283,365,42,26,'#117C87',true);
text(s,'El esquema no vincula pagos con facturas ni sesiones con citas. Requiere reglas claras para interpretar los importes y mantener la coherencia de los datos.',457,337,355,260,25);
text(s,'Objetivos',864,283,365,42,26,'#117C87',true);
text(s,'Organizar las entidades y sus relaciones.\n\nProteger la integridad de los registros.\n\nFacilitar consultas de atención y facturación.',864,337,355,280,25);
s.speakerNotes.text='Fuente: Caso Propuesto/README.md, secciones 1–7, y Modelo Físico/scrip_creacion_db_tablas.sql. La problemática describe limitaciones observables del esquema, no hechos operativos no comprobados. El proyecto entrega una adaptación a SQL Server; no acredita una migración de la aplicación.';

s=slide('Listado de tablas',2);
text(s,'9 tablas en la base therapyflex_crm',50,105,1120,40,26,'#117C87');
const vals=[['Tabla','Entidad','Información principal'],['users','Usuarios','Referencia del usuario que registra datos'],['patients','Pacientes','Datos personales y clínicos generales'],['appointments','Citas','Agenda y agrupación de citas en paquetes'],['sessions','Sesiones clínicas','Tratamiento, evolución y escala de dolor'],['session_files','Archivos clínicos','Metadatos y rutas de archivos de sesiones'],['payments','Pagos','Importes y asociación opcional con una cita'],['invoices','Facturas','Cabecera, estado e importes de facturación'],['invoice_items','Detalles de factura','Conceptos, cantidades y precios'],['google_reviews','Reseñas de Google','Puntuaciones, comentarios y respuestas']];
const table=s.tables.add({rows:10,columns:3,left:50,top:166,width:1180,height:470,columnWidths:[250,260,670],values:vals});
for(let r=0;r<10;r++)for(let c=0;c<3;c++){let cell=table.getCell(r,c);cell.fill=r===0?'#103D52':r%2?'#EFF6F8':'#FFFFFF';cell.text.style={typeface:'Arial',fontSize:22,bold:r===0,color:r===0?'#FFFFFF':'#24374A'};}
table.borders.assign({fill:'#DCE6EA',width:0.5,style:'solid'});
s.speakerNotes.text='Fuente: Modelo Físico/scrip_creacion_db_tablas.sql. Las nueve tablas usan el esquema dbo. users es una referencia local, no un sistema de autenticación. google_reviews no tiene claves foráneas.';

s=slide('Diagrama entidad–relación',3);
await pic(s,'Modelo Entidad Relacion/Diagrama ER - Centro-TerapiaFisica.png',38,111,780,535);
text(s,'El paciente como entidad central',851,121,379,87,29,'#117C87',true);
text(s,'Relaciones 1:N con citas, sesiones, archivos, pagos y facturas.',851,225,369,106,25);
text(s,'Reseñas de Google como entidad independiente.',851,346,369,83,25);
text(s,'Ajustes pendientes del ER',851,458,369,40,24,'#117C87',true);
text(s,'Agregar Usuario–Sesión.\nRetirar Rol para coincidir con el SQL.\nPrecisar relaciones opcionales.',851,510,369,144,22);
s.speakerNotes.text='Fuente visual: Modelo Entidad Relacion/Diagrama ER - Centro-TerapiaFisica.png, conservado como imagen original. Fuente de contraste: Modelo Físico/scrip_creacion_db_tablas.sql. El diagrama omite sessions.created_by y muestra Rol, que no existe en users. Las referencias created_by y payments.appointment_id son opcionales. La cardinalidad máxima 1:N no expresa obligatoriedad.';

s=slide('Modelo lógico',4);
await pic(s,'Modelo Lógico/modelo-logico-centro-terapia.png',32,107,804,550);
text(s,'Tablas, atributos y claves',858,126,370,80,29,'#117C87',true);
text(s,'PK identifica cada registro.\n\nFK conecta tablas relacionadas.\n\nUK restringe valores duplicados.',858,235,365,225,25);
text(s,'Correspondencia con SQL Server',858,489,367,68,25,'#117C87',true);
text(s,'auth.users se adapta a dbo.users.\nLos tipos del diagrama provienen de PostgreSQL.',858,565,367,88,22);
s.speakerNotes.text='Fuente visual: Modelo Lógico/modelo-logico-centro-terapia.png. Fuente explicativa: Caso Propuesto/README.md, secciones 4, 6 y 9. El diagrama conserva uuid, text y timestamptz; el DDL los adapta a uniqueidentifier, nvarchar y datetimeoffset(6). Los detalles del esquema se consultan ampliando la imagen. El SQL es la referencia para nulabilidad y restricciones.';

s=slide('Modelo físico',5);
await pic(s,'Modelo Físico/modelo-fisico.png',32,105,796,552);
text(s,'Implementación en SQL Server',850,121,380,82,29,'#117C87',true);
text(s,'Base: therapyflex_crm\n9 tablas y 12 claves foráneas\n17 índices explícitos',850,231,375,147,25);
text(s,'Integridad de los registros',850,415,375,70,27,'#117C87',true);
text(s,'El archivo y su sesión deben pertenecer al mismo paciente.\n\nNO ACTION impide borrar registros con dependientes.',850,503,375,151,23);
s.speakerNotes.text='Fuentes: Modelo Físico/modelo-fisico.png y Modelo Físico/scrip_creacion_db_tablas.sql. El DDL declara 9 tablas, 12 FK y 17 CREATE INDEX, además de índices asociados a PK y UNIQUE. La FK compuesta de session_files(session_id, patient_id) referencia sessions(id, patient_id). Todas las FK usan ON DELETE NO ACTION. El script de instalación no carga datos ni actualiza estructuras existentes.';

for(let i=0;i<p.slides.items.length;i++){const png=await p.export({slide:p.slides.items[i],format:'png',scale:1.5});await fs.writeFile(path.join(tmp,`slide-${i+1}.png`),new Uint8Array(await png.arrayBuffer()));}
const candidate=path.join(tmp,'draft.pptx');await (await PresentationFile.exportPptx(p)).save(candidate);
const {finalizePresentation}=await import(pathToFileURL(path.join(skill,'container_tools/artifact_tool_utils.mjs')).href);
const result=await finalizePresentation({workspaceDir:root,candidatePath:candidate,finalPath:path.join(root,'Presentacion/Proyecto_Modelamiento_Datos_TherapyFlex.pptx'),pythonExecutable:'C:/Users/JORGE/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe',integrityValidatorPath:path.join(skill,'container_tools/inspect_presentation_package_integrity.py'),layoutValidatorPath:path.join(skill,'container_tools/inspect_presentation_layout_geometry.py'),layoutArgs:['--expected-slide-size-emu','12192000,6858000','--validate-bullet-geometry','--validate-heading-fit','--require-native-table-slide','2'],explicitTotalSlideCount:5,requiredNativeTableOwnerSlides:[2],fontPolicy,verifyArtifactToolImport:true,receiptPath:path.join(tmp,'validation.json')});
console.log(JSON.stringify(result));

