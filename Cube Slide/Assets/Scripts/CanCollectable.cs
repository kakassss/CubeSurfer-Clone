using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CanCollectable : MonoBehaviour
{
    public List<GameObject> cubes = new List<GameObject>();
    public float currentHeight;

    private void Update()
    {
        transform.position = new Vector3(transform.position.x,transform.position.y,transform.parent.position.z + 10);
    }

    private void OnTriggerEnter(Collider target)
    {
        Vector3 targetHeight = target.transform.localScale;
        if (target.tag == "FriendCube")
        {

            currentHeight += targetHeight.y;
            Destroy(target.gameObject);

            GameObject newCube = Instantiate(Resources.Load("Wassap") as GameObject, transform.position - new Vector3(0, currentHeight, 0), Quaternion.identity);
            newCube.transform.SetParent(GameObject.Find("Player").transform);

            newCube.GetComponent<BoxCollider>().isTrigger = false;
            newCube.gameObject.tag = "Untagged";



            transform.position += new Vector3(0, 1, 0);
            cubes.Add(newCube);

        }


    }
}
