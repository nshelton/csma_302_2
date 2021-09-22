using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class materialSwitcher : MonoBehaviour
{

    [SerializeField]
    public List<Material> _materials = new List<Material>();

    [SerializeField]
    public Renderer _renderer;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q)) 
        {
            _renderer.material = _materials[0];
        }

        if (Input.GetKeyDown(KeyCode.W)) 
        {
            _renderer.material = _materials[1];
        }

    }
}
