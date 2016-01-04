//This file was generated from UPPAAL 4.0.6 (rev. 2987), March 2007

/*

*/
A[] lamp.On imply main.Burning

/*

*/
A[] main.ReadyToLoadWafer imply main.total <= 15

/*

*/
A[] main.ReadyToLoadWafer imply (door1.Open and door2.Closed)

/*

*/
A[] door1.Closed or door1.PseudoClosing or door2.Closed or door2.PseudoClosing

/*

*/
A[] managecrash.Crashed or not deadlock
