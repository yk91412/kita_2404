using TMPro;  // TextMeshProUGUI�� ����ϱ� ���� �ʿ�
using System.Collections;
using System.Collections.Generic;
using UnityEngine.XR.ARFoundation;
using UnityEngine;
using UnityEngine.AI;

public class SetNavigationTarget : MonoBehaviour
{
    public TextMeshProUGUI debugText;  // ����� �޽����� ǥ���� TextMeshProUGUI �ʵ�
    [SerializeField]
    private List<GameObject> navTargetObjects;  // ���� Ÿ�� ������Ʈ��
    [SerializeField]
    private LineRenderer line;  // ���� ������
    [SerializeField]
    private GameObject indicator;  // �ε������� ��ü
    [SerializeField]
    private Camera topDownCamera;  // TopDownCamera �ʵ� �߰�
    [SerializeField]
    private ARSessionOrigin arSessionOrigin;  // ARSessionOrigin �߰�

    private NavMeshPath path;  // ��� ����
    private GameObject currentTarget;  // ���� Ÿ��
    private Vector3 lastIndicatorPosition;  // ���� �ε������� ��ġ
    private Vector3 lastTargetPosition;  // ���� Ÿ�� ��ġ

    private void Start()
    {
        path = new NavMeshPath();
        line.positionCount = 0;

        // ARSessionOrigin�� ��ġ�� �������� �ε������� �ʱ�ȭ
        UpdateIndicatorPosition();
    }

    private void UpdateIndicatorPosition()
    {
        // ARSessionOrigin�� ��ġ�� �������� �ε��������� ��ġ�� ������Ʈ�մϴ�.
        Vector3 arPosition = arSessionOrigin.transform.position;
        indicator.transform.position = new Vector3(arPosition.x, indicator.transform.position.y, arPosition.z);
    }

    public void SetTarget(string targetName)
    {
        bool targetFound = false; // Ÿ���� �߰ߵǾ����� Ȯ���ϴ� �÷���

        foreach (GameObject target in navTargetObjects)
        {
            if (target.name.Equals(targetName))
            {
                currentTarget = target;
                lastTargetPosition = currentTarget.transform.position;

                // LineWithArrow ��ũ��Ʈ�� ��ǥ ��ġ ����
                LineWithArrow lineWithArrow = indicator.GetComponent<LineWithArrow>();
                if (lineWithArrow != null)
                {
                    lineWithArrow.points = new Transform[] { indicator.transform, currentTarget.transform }; // ���� ��ġ�� ��ǥ ��ġ�� ����
                    lineWithArrow.UpdateLine(); // ������ ������Ʈ
                }

                UpdatePath();

                // ����� �޽��� �߰�
                debugText.text += $"\nTarget set to: {targetName} at position: {currentTarget.transform.position}";
                targetFound = true; // Ÿ���� ã������ ǥ��
                break; // Ÿ���� ã�����Ƿ� ���� ����
            }
        }

        // Ÿ���� �߰ߵ��� �ʾ��� �� ����� �޽��� �߰�
        if (!targetFound)
        {
            debugText.text += $"\nTarget '{targetName}' not found.";
        }
    }

    private void UpdatePath()
    {
        if (currentTarget != null)
        {
            if (indicator.transform.position != lastIndicatorPosition || currentTarget.transform.position != lastTargetPosition)
            {
                NavMesh.CalculatePath(indicator.transform.position, currentTarget.transform.position, NavMesh.AllAreas, path);

                if (path.status == NavMeshPathStatus.PathComplete)
                {
                    line.positionCount = path.corners.Length;
                    line.SetPositions(path.corners);
                    line.enabled = true;

                    lastIndicatorPosition = indicator.transform.position;
                    lastTargetPosition = currentTarget.transform.position;

                    // TopDownCamera�� �ε������͸� ���󰡵��� ����
                    topDownCamera.transform.position = new Vector3(indicator.transform.position.x, topDownCamera.transform.position.y, indicator.transform.position.z);
                }
                else
                {
                    // �߰� ����� ����
                    debugText.text += $"\nFailed to calculate path. Path status: {path.status}"; // ��� ���� ���
                    debugText.text += $"\nIndicator position: {indicator.transform.position}, Target position: {currentTarget.transform.position}"; // ��ġ ���
                }
            }
        }
    }

    private void Update()
    {
        UpdateIndicatorPosition();  // Indicator ��ġ ������Ʈ

        if (currentTarget != null)
        {
            UpdatePath();
        }
    }
}
