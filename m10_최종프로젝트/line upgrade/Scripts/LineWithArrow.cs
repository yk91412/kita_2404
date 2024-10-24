using UnityEngine; // MonoBehaviour, Transform, LineRenderer�� ����ϱ� ���� �ʿ�

public class LineWithArrow : MonoBehaviour
{
    public Transform[] points; // LineRenderer�� ���� ����� ����Ʈ��
    private LineRenderer lineRenderer;

    void Start()
    {
        lineRenderer = GetComponent<LineRenderer>();
        lineRenderer.material.mainTextureScale = new Vector2(1, 1); // ȭ��ǥ�� ũ�⸦ ����
        lineRenderer.textureMode = LineTextureMode.Tile; // Texture Mode�� Tile�� ����
        UpdateLine();
    }

    // ��θ� �������� ������Ʈ�ϴ� �Լ�
    public void UpdateLine() // ���� �����ڸ� public���� ����
    {
        if (points.Length == 0) return; // ����Ʈ�� ������ �������� ����

        // ����� �� ������ ����
        lineRenderer.positionCount = points.Length;

        // �� ����Ʈ�� ��ġ�� LineRenderer�� ����
        for (int i = 0; i < points.Length; i++)
        {
            lineRenderer.SetPosition(i, points[i].position);
        }

        // ������ ���� ȭ��ǥ �̹��� �߰� (Material�� �̿�)
        if (points.Length > 1)
        {
            // ������ �� ����Ʈ�� �̿��� ȭ��ǥ ���� ���
            Vector3 direction = (points[points.Length - 1].position - points[points.Length - 2].position).normalized;
            float arrowLength = 0.5f; // ȭ��ǥ�� ����
            Vector3 arrowHeadPosition = points[points.Length - 1].position - direction * arrowLength;

            // ȭ��ǥ�� �׸��� ���� LineRenderer�� ������ ���� ȭ��ǥ �Ӹ� ��ġ�� ����
            lineRenderer.SetPosition(points.Length - 1, arrowHeadPosition);
        }
    }

    void Update()
    {
        UpdateLine(); // �� �����Ӹ��� ��θ� ������Ʈ
    }
}
