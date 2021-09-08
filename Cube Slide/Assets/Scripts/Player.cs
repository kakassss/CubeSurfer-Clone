using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;
using TMPro;
public class Player : MonoBehaviour
{
    public static Player instance;

    public float speedX;
    public float speedY;
    public float speedZ;

    private bool straightMov;
    private bool canMove;

    private BoxCollider cc;
    private Rigidbody rb;

    public List<GameObject> cubes = new List<GameObject>();
    public float currentHeight;


    Vector3 lastMousePos;
    Vector3 direction;

    public Transform childTransform;
    public Transform childTransform2;
    public Transform childTransform3;


    private GameUI gameUI;

    private bool gameOver;
    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        instance = this;
        cc = GetComponent<BoxCollider>();
   
    }
    private void Start()
    {
        straightMov = false;
        cc.isTrigger = true;
        canMove = true;

        gameUI = FindObjectOfType<GameUI>();

        childTransform = gameObject.transform.GetChild(0);
        childTransform2 = gameObject.transform.GetChild(1);
        childTransform3 = gameObject.transform.GetChild(2);
        currentHeight = 1;

    }
    
    private void Update()
    {
        if (childTransform3.parent == null && gameOver)
        {
            Debug.Log("game over");
            straightMov = false;
            rb.velocity = Vector3.zero;
            speedZ = 0;
            canMove = false;
            gameUI.GameOverUI();
        }
        if (Obstacle.canDestroy)
        {
            Debug.Log("You win");
            straightMov = false;
            rb.velocity = Vector3.zero;
            speedZ = 0;
            canMove = false;
        }
        //transform.position = new Vector3(transform.position.x,transform.position.y,transform.parent.position.z + 15f);
        StraightMovement();
        Movement();
    }   
    private void StraightMovement()
    {
        if(straightMov)
            rb.velocity = transform.forward * speedZ;
    }
    private void Movement()
    {
        if (canMove)
        {
            if (Input.GetMouseButtonDown(0))
            {
                lastMousePos.x = Input.mousePosition.x;
                straightMov = true;
            }
            if (Input.GetMouseButton(0))
            {
                direction.x = lastMousePos.x - Input.mousePosition.x;
                lastMousePos.x = Input.mousePosition.x;

                direction = new Vector3(direction.x, 0, 0);

                Vector3 moveForce = Vector3.ClampMagnitude(direction, 4);

                rb.AddRelativeForce(-moveForce / 2f, ForceMode.Impulse);
            }
            if (Input.GetMouseButtonUp(0))
            {
                rb.AddRelativeForce(Vector3.zero);
            }
        }       
    }
    
    
    private void OnTriggerEnter(Collider target)
    {
        Vector3 targetHeight = target.transform.localScale;
        if (target.CompareTag("FriendCube"))
        {
           

            currentHeight += targetHeight.y;
            Destroy(target.gameObject);
            if(transform.rotation == Quaternion.Euler(0, 90, 0))
            {
                GameObject newCube = Instantiate(Resources.Load("Wassap") as GameObject, transform.position - new Vector3(0, currentHeight, 0), Quaternion.Euler(0,90,0));

                newCube.transform.SetParent(GameObject.Find("Player").transform);

                newCube.GetComponent<BoxCollider>().isTrigger = false;
                newCube.gameObject.tag = "Untagged";

                cubes.Add(newCube);

                StartCoroutine(ShowPlusOne(newCube));
            }
            else
            {
                GameObject newCube = Instantiate(Resources.Load("Wassap") as GameObject, transform.position - new Vector3(0, currentHeight, 0), Quaternion.identity);
                newCube.transform.SetParent(GameObject.Find("Player").transform);

                newCube.GetComponent<BoxCollider>().isTrigger = false;
                newCube.gameObject.tag = "Untagged";

                cubes.Add(newCube);

                StartCoroutine(ShowPlusOne(newCube));
            }

            transform.position += new Vector3(0, 1, 0);           
        }
        if (target.CompareTag("XTag") && cubes.Count == 1)
        {
            gameOver = false;
            Debug.Log("yoooo");
            StartCoroutine(YouWinX());
        }
        else
        {
            gameOver = true;          
        }
    }
    private IEnumerator YouWinX()
    {
        yield return new WaitForSeconds(0.4f);
        Obstacle.canDestroy = true;
        gameUI.YouWinUI();
    }
    private IEnumerator ShowPlusOne(GameObject myCube)
    {
        myCube.transform.GetChild(0).gameObject.SetActive(true);
        yield return new WaitForSeconds(0.3f);
        myCube.transform.GetChild(0).gameObject.SetActive(false);
    }
 
    public void DownChild()
    {
        
        Debug.Log(childTransform.name); 
        childTransform.localPosition -= new Vector3(0, 1, 0);

    }
    

}
