// Uses only the public client configuration; never a service-account key.
// Creates disposable records and anonymous users, then removes its own fixtures.
import assert from 'node:assert/strict';
import {initializeApp,deleteApp} from 'firebase/app';
import {getAuth,signInAnonymously,deleteUser} from 'firebase/auth';
import {getFirestore,doc,setDoc,getDoc,updateDoc,deleteDoc,serverTimestamp,terminate} from 'firebase/firestore';

const config={
  apiKey:'AIzaSyCEagjjgKadI7DyMGmVa6E3g_ZUjRxxuDM',
  projectId:'madlab-f5bad',
  appId:'1:706450556489:web:6652cae4c355f4524da198',
  messagingSenderId:'706450556489',
};
const aliceApp=initializeApp(config,'verification-owner');
const bobApp=initializeApp(config,'verification-other-user');
const aliceAuth=getAuth(aliceApp),bobAuth=getAuth(bobApp);
const aliceDb=getFirestore(aliceApp),bobDb=getFirestore(bobApp);
let ref;
try {
  const alice=await signInAnonymously(aliceAuth);
  await signInAnonymously(bobAuth);
  ref=doc(aliceDb,`users/${alice.user.uid}/students/verification-${Date.now()}`);
  await setDoc(ref,{name:'MadLab verification',email:'verification@example.com',createdAt:serverTimestamp(),updatedAt:serverTimestamp()});
  assert.equal((await getDoc(ref)).data().name,'MadLab verification');
  await updateDoc(ref,{name:'MadLab verification updated',updatedAt:serverTimestamp()});
  assert.equal((await getDoc(ref)).data().name,'MadLab verification updated');
  await assert.rejects(getDoc(doc(bobDb,ref.path)),error=>error.code==='permission-denied');
  await deleteDoc(ref);
  assert.equal((await getDoc(ref)).exists(),false);
  console.log('PASS: live anonymous authentication, create/read/update/delete, server timestamps and cross-user read denial');
} finally {
  if(ref) await deleteDoc(ref).catch(()=>{});
  if(aliceAuth.currentUser) await deleteUser(aliceAuth.currentUser);
  if(bobAuth.currentUser) await deleteUser(bobAuth.currentUser);
  await Promise.all([terminate(aliceDb),terminate(bobDb)]);
  await Promise.all([deleteApp(aliceApp),deleteApp(bobApp)]);
}
