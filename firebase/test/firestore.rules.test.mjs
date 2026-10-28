import {readFile} from 'node:fs/promises';
import {after, before, beforeEach, test} from 'node:test';
import {initializeTestEnvironment, assertFails, assertSucceeds} from '@firebase/rules-unit-testing';
import {doc, collection, setDoc, getDoc, getDocs, updateDoc, deleteDoc, serverTimestamp, Timestamp} from 'firebase/firestore';

let environment;
before(async () => {
  environment = await initializeTestEnvironment({
    projectId: 'demo-madlab',
    firestore: {host:'127.0.0.1', port:8081, rules:await readFile(new URL('../firestore.rules',import.meta.url),'utf8')},
  });
});
beforeEach(async () => environment.clearFirestore());
after(async () => environment?.cleanup());
const record = (overrides={}) => ({name:'Ada',email:'ada@example.com',createdAt:serverTimestamp(),updatedAt:serverTimestamp(),...overrides});
const student = (db, owner='alice') => doc(db,`users/${owner}/students/student-a`);

test('owner can create, list, read, update and delete',async()=>{
  const db=environment.authenticatedContext('alice').firestore(), ref=student(db);
  await assertSucceeds(setDoc(ref,record()));
  await assertSucceeds(getDocs(collection(db,'users/alice/students')));
  await assertSucceeds(getDoc(ref));
  await assertSucceeds(updateDoc(ref,{name:'Ada Lovelace',updatedAt:serverTimestamp()}));
  await assertSucceeds(deleteDoc(ref));
});
test('unauthenticated clients cannot read or write',async()=>{
  const db=environment.unauthenticatedContext().firestore();
  await assertFails(setDoc(student(db),record()));
  await assertFails(getDoc(student(db)));
  await assertFails(getDocs(collection(db,'users/alice/students')));
});
test('another user cannot read, query, update or delete owner records',async()=>{
  const alice=environment.authenticatedContext('alice').firestore();
  await setDoc(student(alice),record());
  const bob=environment.authenticatedContext('bob').firestore(), ref=student(bob);
  await assertFails(getDoc(ref));
  await assertFails(getDocs(collection(bob,'users/alice/students')));
  await assertFails(updateDoc(ref,{name:'Changed',updatedAt:serverTimestamp()}));
  await assertFails(deleteDoc(ref));
  await assertFails(setDoc(doc(bob,'users/alice/students/another'),record()));
});
test('malformed name and email are rejected',async()=>{
  const db=environment.authenticatedContext('alice').firestore(), ref=student(db);
  for(const invalid of [{name:''},{name:'   '},{name:42},{name:'a'.repeat(101)},{email:'invalid'},{email:42},{email:'a'.repeat(250)+'@x.com'}]) {
    await assertFails(setDoc(ref,record(invalid)));
  }
});
test('unknown fields and missing timestamps are rejected',async()=>{
  const ref=student(environment.authenticatedContext('alice').firestore());
  await assertFails(setDoc(ref,record({admin:true})));
  await assertFails(setDoc(ref,{name:'Ada',email:'ada@example.com'}));
});
test('timestamps must be server timestamps and creation time is immutable',async()=>{
  const ref=student(environment.authenticatedContext('alice').firestore());
  await assertFails(setDoc(ref,record({createdAt:Timestamp.fromMillis(0)})));
  await assertFails(setDoc(ref,record({updatedAt:Timestamp.fromMillis(0)})));
  await assertSucceeds(setDoc(ref,record()));
  await assertFails(updateDoc(ref,{createdAt:Timestamp.fromMillis(0),updatedAt:serverTimestamp()}));
});
test('unrelated collection access is denied',async()=>{
  const db=environment.authenticatedContext('alice').firestore();
  await assertFails(setDoc(doc(db,'students/legacy'),record()));
  await assertFails(setDoc(doc(db,'admin/settings'),{admin:true}));
});
