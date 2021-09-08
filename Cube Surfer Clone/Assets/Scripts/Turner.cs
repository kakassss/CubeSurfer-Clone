using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Turner : MonoBehaviour
{
    private Player player;
    private Camera playerCamera;

    
    private void Start()
    {
        player = FindObjectOfType<Player>();
        playerCamera = FindObjectOfType<Camera>();
    }
    private void OnTriggerEnter(Collider other)
    {      
        other.transform.DORotateQuaternion(Quaternion.Euler(transform.rotation.x, 90, transform.rotation.z), 0.5f);   
    }
    
}
