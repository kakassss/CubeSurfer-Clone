using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class GameUI : MonoBehaviour
{
    public static GameUI instance;


    public Image gameOverImage;
    public TextMeshProUGUI gameOverText;

    public TextMeshProUGUI plusOneText;


    public Image youWinImage;
    public TextMeshProUGUI youWinText;
    

    private void Awake()
    {
        instance = this;
    }
    // Start is called before the first frame update
    void Start()
    {
        gameOverImage.enabled = false;
        gameOverText.enabled = false;
        plusOneText.gameObject.SetActive(false);

        youWinImage.enabled = false;
        youWinText.enabled = false;
    }
    public IEnumerator PlusOneText()
    {
        plusOneText.gameObject.SetActive(true);
        yield return new WaitForSeconds(0.3f);
        plusOneText.gameObject.SetActive(false);
    }
    public void GameOverUI()
    {
        gameOverImage.enabled = true;
        gameOverText.enabled = true;
    }
    public void YouWinUI()
    {
        youWinText.text = "You Win";
        youWinText.enabled = true;
        youWinImage.enabled = true;
    }
    
}
