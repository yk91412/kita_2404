using System.Collections;
using TMPro;  // TextMeshPro ����� ���� �߰�
using UnityEngine;
using UnityEngine.Networking;
using Newtonsoft.Json.Linq;  // Newtonsoft.Json�� ����ϱ� ���� ���ӽ����̽� �߰�


public class LLMHandler : MonoBehaviour
{
    public TextMeshProUGUI debugText;  // TextMeshProUGUI ���� �ʵ� �߰�
    private string openAIKey = "";
    private string MODEL = "gpt-4o-mini-2024-07-18";  // ����Ϸ��� OpenAI ��

    private string[] targetAnchors = { "Toilet", "Elevator", "Office", "Lounge" };

    public void GetTargetFromText(string userInput)
    {
        // ù ��° ����� �ؽ�Ʈ�� �ʱ�ȭ
        debugText.text = "Input Voice: " + userInput;  // ���޵� �ؽ�Ʈ ���
        StartCoroutine(SendOpenAIRequest(userInput));
    }

    private IEnumerator SendOpenAIRequest(string userInput)
    {
        // targetStr ������ �޼��� �ȿ��� �����ϰ� �ʱ�ȭ
        string targetsStr = string.Join(", ", targetAnchors);
        string systemMessage = $@"
    ����� �Էµ� �ؽ�Ʈ ������ �������� ã�� ��ǥ target�� �����ϴ� �Ǹ��� assistant�Դϴ�.
    
    ** ��� ���� **
        1. �Էµ� �ؽ�Ʈ ������ �������� ã�� ���ϴ� �ؽ�Ʈ�� ���� ���
        �������ϴ� �������� ��ȯ�մϴ�.
        ��, {targetsStr}�� ���� �������� ��ȯ���� �ʽ��ϴ�.
            �Էµ� �ؽ�Ʈ�� ������ ��� ��ҹ��� �������� �ʽ��ϴ�.

            ����:
            - ""lounge�� ����"" �� [""Lounge""]
            - ""Lounge�� ������ ���� ��������"" �� [""Lounge""]

        ������, ������ ��ȯ �� list{{targetsStr}} �������θ� ����մϴ�.
        �ٸ� �ΰ����� ������ ���� �ʽ��ϴ�.
        
        ����:
        - ""ȭ����� ����?"" �� [""Toilet""]
        - ""toilet�� ��� �ֳ���?"" �� [""Toilet""]

        2. �Էµ� �ؽ�Ʈ ������ �������� ã�� ���ϴ� �ؽ�Ʈ�� ���� ���
        �ؽ�Ʈ�� �亯�ϴ� �������� ����մϴ�.
        ������ �ϰ� �ݷ��ϴ� ������ �亯�մϴ�.
        
        �Էµ� �ؽ�Ʈ�� ������ ��� ����� ���մϴ�.
        �ѱ����� ��� �ѱ���� ���մϴ�.
        �Էµ� �� ���缭 �亯�� �մϴ�.";



        // JSON ���̷ε� ����
        string jsonPayload = $"{{\"model\":\"{MODEL}\",\"messages\":[{{\"role\":\"system\",\"content\":\"{systemMessage}\"}},{{\"role\":\"user\",\"content\":\"{userInput}\"}}],\"max_tokens\":50,\"temperature\":0.8}}";

        // debugText.text += "\nOpenAI request payload created. Sending to OpenAI...";  // ���̷ε尡 �����Ǿ����� �˸�
        Debug.Log("JSON Payload: " + jsonPayload);  // ���۵Ǵ� JSON ���̷ε� ���

        UnityWebRequest request = new UnityWebRequest("https://api.openai.com/v1/chat/completions", "POST");
        byte[] bodyRaw = new System.Text.UTF8Encoding().GetBytes(jsonPayload);
        request.uploadHandler = new UploadHandlerRaw(bodyRaw);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");
        request.SetRequestHeader("Authorization", "Bearer " + openAIKey);

        yield return request.SendWebRequest();

        if (request.result == UnityWebRequest.Result.Success)
        {
            // debugText.text += "\nOpenAI response received. Parsing response...";  // ���� ����
            Debug.Log("OpenAI Response: " + request.downloadHandler.text);  // ���� ������ ���

            string targetName = ParseOpenAIResponse(request.downloadHandler.text);
            debugText.text += "\nDestination: " + targetName;

            // ���õ� Ÿ���� SetNavigationTarget ��ũ��Ʈ�� ����
            FindObjectOfType<SetNavigationTarget>().SetTarget(targetName);
        }
        else
        {
            debugText.text += $"\nError in LLM SendOpenAIRequest Step: {request.error}, Status Code: {request.responseCode}";
            Debug.LogError("OpenAI API Request Error: " + request.downloadHandler.text);
        }
    }

    private string ParseOpenAIResponse(string response)
    {
        // JSON ���� �Ľ�
        JObject jsonResponse = JObject.Parse(response);
        string targetName = jsonResponse["choices"][0]["message"]["content"].ToString().Trim();

        // debugText.text += "\nParsed Target Name: " + targetName;
        return targetName;
    }
}
