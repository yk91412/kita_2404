using System.Collections;
using TMPro;  // TextMeshPro 사용을 위해 추가
using UnityEngine;
using UnityEngine.Networking;
using Newtonsoft.Json.Linq;  // Newtonsoft.Json을 사용하기 위한 네임스페이스 추가


public class LLMHandler : MonoBehaviour
{
    public TextMeshProUGUI debugText;  // TextMeshProUGUI 참조 필드 추가
    private string openAIKey = "";
    private string MODEL = "gpt-4o-mini-2024-07-18";  // 사용하려는 OpenAI 모델

    private string[] targetAnchors = { "Toilet", "Elevator", "Office", "Lounge" };

    public void GetTargetFromText(string userInput)
    {
        // 첫 번째 디버그 텍스트는 초기화
        debugText.text = "Input Voice: " + userInput;  // 전달된 텍스트 출력
        StartCoroutine(SendOpenAIRequest(userInput));
    }

    private IEnumerator SendOpenAIRequest(string userInput)
    {
        // targetStr 변수를 메서드 안에서 선언하고 초기화
        string targetsStr = string.Join(", ", targetAnchors);
        string systemMessage = $@"
    당신은 입력된 텍스트 내에서 목적지를 찾아 목표 target을 설정하는 훌륭한 assistant입니다.
    
    ** 출력 형식 **
        1. 입력된 텍스트 내에서 목적지를 찾길 원하는 텍스트가 있을 경우
        가고자하는 목적지를 반환합니다.
        단, {targetsStr}에 없는 목적지는 반환하지 않습니다.
            입력된 텍스트가 영어일 경우 대소문자 구분하지 않습니다.

            예시:
            - ""lounge가 어디야"" → [""Lounge""]
            - ""Lounge로 가려면 어디로 가야하지"" → [""Lounge""]

        무조건, 목적지 반환 시 list{{targetsStr}} 형식으로만 출력합니다.
        다른 부가적인 설명은 하지 않습니다.
        
        예시:
        - ""화장실이 어디야?"" → [""Toilet""]
        - ""toilet이 어디 있나요?"" → [""Toilet""]

        2. 입력된 텍스트 내에서 목적지를 찾길 원하는 텍스트가 없을 경우
        텍스트에 답변하는 형식으로 출력합니다.
        공감을 하고 격려하는 말투로 답변합니다.
        
        입력된 텍스트가 영어일 경우 영어로 답합니다.
        한국어일 경우 한국어로 답합니다.
        입력된 언어에 맞춰서 답변을 합니다.";



        // JSON 페이로드 구성
        string jsonPayload = $"{{\"model\":\"{MODEL}\",\"messages\":[{{\"role\":\"system\",\"content\":\"{systemMessage}\"}},{{\"role\":\"user\",\"content\":\"{userInput}\"}}],\"max_tokens\":50,\"temperature\":0.8}}";

        // debugText.text += "\nOpenAI request payload created. Sending to OpenAI...";  // 페이로드가 생성되었음을 알림
        Debug.Log("JSON Payload: " + jsonPayload);  // 전송되는 JSON 페이로드 출력

        UnityWebRequest request = new UnityWebRequest("https://api.openai.com/v1/chat/completions", "POST");
        byte[] bodyRaw = new System.Text.UTF8Encoding().GetBytes(jsonPayload);
        request.uploadHandler = new UploadHandlerRaw(bodyRaw);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");
        request.SetRequestHeader("Authorization", "Bearer " + openAIKey);

        yield return request.SendWebRequest();

        if (request.result == UnityWebRequest.Result.Success)
        {
            // debugText.text += "\nOpenAI response received. Parsing response...";  // 응답 받음
            Debug.Log("OpenAI Response: " + request.downloadHandler.text);  // 응답 내용을 출력

            string targetName = ParseOpenAIResponse(request.downloadHandler.text);
            debugText.text += "\nDestination: " + targetName;

            // 선택된 타겟을 SetNavigationTarget 스크립트로 전달
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
        // JSON 응답 파싱
        JObject jsonResponse = JObject.Parse(response);
        string targetName = jsonResponse["choices"][0]["message"]["content"].ToString().Trim();

        // debugText.text += "\nParsed Target Name: " + targetName;
        return targetName;
    }
}
