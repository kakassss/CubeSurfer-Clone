using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Camera : MonoBehaviour
{
    public static Camera instance;

    

    private Rigidbody rb;


    public GameObject player;
    public GameObject child;
    public float speed;


    public Vector3 lookOffset = new Vector3(33, -10, 0);

    private void Awake()
    {
        instance = this;      
    }
    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        player = GameObject.Find("2Player");
        child = GameObject.Find("CameraFollow");       
    }
   
    private void Update()
    {
        CameraDowner();      
    }
    private void CameraDowner()
    {
        transform.position = Vector3.Lerp(transform.position, child.transform.position, 1f);     
        transform.DOLookAt(player.transform.position, 0.2f, AxisConstraint.None, null);       
    }
}
