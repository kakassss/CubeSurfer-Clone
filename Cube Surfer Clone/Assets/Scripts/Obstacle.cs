using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Obstacle : MonoBehaviour
{
    private Camera camera1;
    public static bool rotate;


    private Player myPlayer;

    public static bool canDestroy;
    

    private void Awake()
    {
        myPlayer = FindObjectOfType<Player>();
        camera1 = FindObjectOfType<Camera>();
        
    }
    private void Start()
    {
        canDestroy = false;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
            Destroy(other.gameObject,10f);

        other.transform.SetParent(null);
        myPlayer.cubes.Remove(other.gameObject);

        myPlayer.childTransform.transform.DOBlendableLocalMoveBy(new Vector3(0, -1, 0), 0.1f, false);
        myPlayer.childTransform2.transform.DOBlendableLocalMoveBy(new Vector3(0, -1, 0), 0.1f, false);

        if (canDestroy)
        {            
            Destroy(other.gameObject, 1f);
        }
      
    }   
}
