using UnityEngine; // MonoBehaviour, Transform, LineRenderer를 사용하기 위해 필요

public class LineWithArrow : MonoBehaviour
{
    public Transform[] points; // LineRenderer가 따라갈 경로의 포인트들
    private LineRenderer lineRenderer;

    void Start()
    {
        lineRenderer = GetComponent<LineRenderer>();
        lineRenderer.material.mainTextureScale = new Vector2(1, 1); // 화살표의 크기를 조절
        lineRenderer.textureMode = LineTextureMode.Tile; // Texture Mode를 Tile로 설정
        UpdateLine();
    }

    // 경로를 동적으로 업데이트하는 함수
    public void UpdateLine() // 접근 제한자를 public으로 변경
    {
        if (points.Length == 0) return; // 포인트가 없으면 실행하지 않음

        // 경로의 점 개수를 설정
        lineRenderer.positionCount = points.Length;

        // 각 포인트의 위치를 LineRenderer에 설정
        for (int i = 0; i < points.Length; i++)
        {
            lineRenderer.SetPosition(i, points[i].position);
        }

        // 마지막 점에 화살표 이미지 추가 (Material을 이용)
        if (points.Length > 1)
        {
            // 마지막 두 포인트를 이용해 화살표 방향 계산
            Vector3 direction = (points[points.Length - 1].position - points[points.Length - 2].position).normalized;
            float arrowLength = 0.5f; // 화살표의 길이
            Vector3 arrowHeadPosition = points[points.Length - 1].position - direction * arrowLength;

            // 화살표를 그리기 위해 LineRenderer의 마지막 점을 화살표 머리 위치로 설정
            lineRenderer.SetPosition(points.Length - 1, arrowHeadPosition);
        }
    }

    void Update()
    {
        UpdateLine(); // 매 프레임마다 경로를 업데이트
    }
}
