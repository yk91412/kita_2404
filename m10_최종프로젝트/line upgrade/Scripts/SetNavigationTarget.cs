using TMPro;  // TextMeshProUGUI를 사용하기 위해 필요
using System.Collections;
using System.Collections.Generic;
using UnityEngine.XR.ARFoundation;
using UnityEngine;
using UnityEngine.AI;

public class SetNavigationTarget : MonoBehaviour
{
    public TextMeshProUGUI debugText;  // 디버깅 메시지를 표시할 TextMeshProUGUI 필드
    [SerializeField]
    private List<GameObject> navTargetObjects;  // 여러 타겟 오브젝트들
    [SerializeField]
    private LineRenderer line;  // 라인 렌더러
    [SerializeField]
    private GameObject indicator;  // 인디케이터 객체
    [SerializeField]
    private Camera topDownCamera;  // TopDownCamera 필드 추가
    [SerializeField]
    private ARSessionOrigin arSessionOrigin;  // ARSessionOrigin 추가

    private NavMeshPath path;  // 경로 정보
    private GameObject currentTarget;  // 현재 타겟
    private Vector3 lastIndicatorPosition;  // 이전 인디케이터 위치
    private Vector3 lastTargetPosition;  // 이전 타겟 위치

    private void Start()
    {
        path = new NavMeshPath();
        line.positionCount = 0;

        // ARSessionOrigin의 위치를 기준으로 인디케이터 초기화
        UpdateIndicatorPosition();
    }

    private void UpdateIndicatorPosition()
    {
        // ARSessionOrigin의 위치를 기준으로 인디케이터의 위치를 업데이트합니다.
        Vector3 arPosition = arSessionOrigin.transform.position;
        indicator.transform.position = new Vector3(arPosition.x, indicator.transform.position.y, arPosition.z);
    }

    public void SetTarget(string targetName)
    {
        bool targetFound = false; // 타겟이 발견되었는지 확인하는 플래그

        foreach (GameObject target in navTargetObjects)
        {
            if (target.name.Equals(targetName))
            {
                currentTarget = target;
                lastTargetPosition = currentTarget.transform.position;

                // LineWithArrow 스크립트에 목표 위치 전달
                LineWithArrow lineWithArrow = indicator.GetComponent<LineWithArrow>();
                if (lineWithArrow != null)
                {
                    lineWithArrow.points = new Transform[] { indicator.transform, currentTarget.transform }; // 현재 위치와 목표 위치를 설정
                    lineWithArrow.UpdateLine(); // 라인을 업데이트
                }

                UpdatePath();

                // 디버그 메시지 추가
                debugText.text += $"\nTarget set to: {targetName} at position: {currentTarget.transform.position}";
                targetFound = true; // 타겟을 찾았음을 표시
                break; // 타겟을 찾았으므로 루프 종료
            }
        }

        // 타겟이 발견되지 않았을 때 디버그 메시지 추가
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

                    // TopDownCamera가 인디케이터를 따라가도록 설정
                    topDownCamera.transform.position = new Vector3(indicator.transform.position.x, topDownCamera.transform.position.y, indicator.transform.position.z);
                }
                else
                {
                    // 추가 디버깅 정보
                    debugText.text += $"\nFailed to calculate path. Path status: {path.status}"; // 경로 상태 출력
                    debugText.text += $"\nIndicator position: {indicator.transform.position}, Target position: {currentTarget.transform.position}"; // 위치 출력
                }
            }
        }
    }

    private void Update()
    {
        UpdateIndicatorPosition();  // Indicator 위치 업데이트

        if (currentTarget != null)
        {
            UpdatePath();
        }
    }
}
