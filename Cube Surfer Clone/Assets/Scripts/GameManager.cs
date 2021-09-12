using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public int cubeSpawnNumber = 4;
    public int zPos = 4;

    public Material[] materials;

    bool enemyCanSpawn;
    // Start is called before the first frame update
    void Start()
    {
        SpawnRandomCube();
        enemyCanSpawn = false;
    }
    
    private void SpawnRandomCube()
    {
        for (int i = 0; i < cubeSpawnNumber; i++)
        {
            GameObject friendcube;
            GameObject enemyCube;

            float random = Random.value;

            if(random > 0.4f)
            {
                //wassap = cube prefab
                friendcube = Instantiate(Resources.Load("Wassap") as GameObject, transform.position, Quaternion.identity);


                friendcube.transform.SetParent(GameObject.Find("GameManager").transform);
                friendcube.transform.localPosition = new Vector3(Random.Range(-0.9f, 0.9f), 1, zPos);

                friendcube.GetComponent<BoxCollider>().isTrigger = true;
                friendcube.GetComponent<MeshRenderer>().material.color = materials[Random.Range(0, 3)].color;

                enemyCanSpawn = true;

                
                
            }
            else if(random < 0.3f && enemyCanSpawn)
            {
                enemyCube = Instantiate(Resources.Load("EnemyCube") as GameObject, new Vector3(0, 1, zPos), Quaternion.identity);
                enemyCube.transform.SetParent(GameObject.Find("GameManager").transform);
            }
            zPos += 5;
            
        }
    }
}
