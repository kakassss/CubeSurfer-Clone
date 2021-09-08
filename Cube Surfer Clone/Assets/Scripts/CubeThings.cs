using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;


public class CubeThings : MonoBehaviour
{
    private Player player;

    private void Start()
    {
        player = FindObjectOfType<Player>();
        StartCoroutine(CheckHitSomethingCube());
    }
    Vector3 targetHeight;
    private IEnumerator CheckHitSomethingCube()
    {
        while (true)
        {
            yield return new WaitForSeconds(0.25f);
            RaycastHit hit;

            if (!Physics.Raycast(transform.position, Vector3.down, out hit,1f))
            {
                transform.DOBlendableMoveBy(new Vector3(0, -1, 0), 0.1f, false).SetEase(Ease.OutBounce);
            }
            if(Physics.Raycast(transform.position, Vector3.down, out hit, 1f))
            {
                DOTween.Kill(hit, false);
            }
        }     
    }
    
    private void OnDrawGizmos()
    {
        Debug.DrawLine(transform.position, transform.position - new Vector3(0,0.7f,0),Color.blue);
    }

}
