using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;
using System;
using UnityEngine.Android;  // Permission 클래스 사용을 위해 추가

public class SpeechToTextHandler : MonoBehaviour
{
    public TextMeshProUGUI debugText;
    private string apiKey = "";  // Google API 키
    private bool isListening = false;

    public void StartVoiceRecognition()
    {
        // 권한이 부여되지 않은 경우 권한 요청
        if (!Permission.HasUserAuthorizedPermission(Permission.Microphone))
        {
            Permission.RequestUserPermission(Permission.Microphone);
            debugText.text = "Requesting microphone permission...";
            return;  // 권한이 허가될 때까지 대기
        }

        // 권한이 이미 부여된 경우 음성 인식 시작
        if (!isListening)
        {
            isListening = true;
            debugText.text = "Voice Recognition Started";
            StartCoroutine(RecordAudioAndSendToGoogle());
        }
    }

    private IEnumerator RecordAudioAndSendToGoogle()
    {
        // 마이크 장치 확인
        if (Microphone.devices.Length == 0)
        {
            debugText.text = "No microphones found.";
            yield break;
        }

        // Step 1: Start recording
        AudioClip audioClip = Microphone.Start(null, false, 5, 44100);
        if (Microphone.IsRecording(null))
        {
            debugText.text = "Microphone is recording...";
        }
        else
        {
            debugText.text = "Microphone failed to start recording. Please check microphone settings and permissions.";
            yield break;
        }

        // 5초간 녹음 대기
        yield return new WaitForSeconds(5);

        // Step 2: Stop recording and process audio
        if (Microphone.IsRecording(null))
        {
            Microphone.End(null);
            debugText.text = "Microphone stopped, preparing to send audio...";

            // Convert AudioClip to byte array (WAV format)
            byte[] audioData = ConvertAudioClipToWav(audioClip);

            if (audioData != null)
            {
                debugText.text = $"Audio data size: {audioData.Length} bytes. Sending to Google...";
                yield return SendAudioToGoogle(audioData);
            }
            else
            {
                debugText.text = "Failed to convert audio to WAV format.";
            }

            // Reset the listening state after the process is completed
            isListening = false;
        }
        else
        {
            debugText.text = "Failed to stop recording.";
        }
    }

    private IEnumerator SendAudioToGoogle(byte[] audioData)
    {
        if (audioData == null || audioData.Length == 0)
        {
            debugText.text = "Audio data is empty or null.";
            yield break;
        }

        // Convert byte array to Base64
        string base64Audio = Convert.ToBase64String(audioData);

        // JSON payload 구성 (코랩과 동일한 형식으로 수정)
        string jsonPayload = "{\"config\":{\"encoding\":\"LINEAR16\",\"sampleRateHertz\":44100,\"languageCode\":\"ko-KR\"},\"audio\":{\"content\":\"" + base64Audio + "\"}}";

        // JSON 페이로드 확인을 위한 디버그 로그 추가
        Debug.Log("JSON Payload: " + jsonPayload);

        UnityWebRequest request = new UnityWebRequest("https://speech.googleapis.com/v1/speech:recognize?key=" + apiKey, "POST");
        byte[] bodyRaw = new System.Text.UTF8Encoding().GetBytes(jsonPayload);
        request.uploadHandler = new UploadHandlerRaw(bodyRaw);
        request.downloadHandler = new DownloadHandlerBuffer();
        request.SetRequestHeader("Content-Type", "application/json");

        // 요청 전송 및 응답 대기
        yield return request.SendWebRequest();

        // API 응답 확인
        if (request.result == UnityWebRequest.Result.Success)
        {
            debugText.text = "Google response received. Parsing response...";
            string recognizedText = ParseResponse(request.downloadHandler.text);
            debugText.text = $"Recognized Text: {recognizedText}";

            // LLMHandler로 텍스트를 전달
            FindObjectOfType<LLMHandler>().GetTargetFromText(recognizedText);
        }
        else
        {
            // 에러 메시지와 응답 내용 출력
            debugText.text = $"Error: {request.error}, Status Code: {request.responseCode}";
            Debug.LogError($"Google API Request Error: {request.error}, Response Code: {request.responseCode}, Detailed Response: {request.downloadHandler.text}");
        }
    }

    // AudioClip을 WAV 파일로 변환하는 함수 (메모리 상에서 처리)
    private byte[] ConvertAudioClipToWav(AudioClip clip)
    {
        try
        {
            using (var memoryStream = new System.IO.MemoryStream())
            {
                byte[] header = WriteWavHeader(clip);
                memoryStream.Write(header, 0, header.Length);

                byte[] audioData = ConvertAudioClipToPCM(clip);
                memoryStream.Write(audioData, 0, audioData.Length);

                return memoryStream.ToArray();
            }
        }
        catch (Exception ex)
        {
            debugText.text = $"Error converting audio to WAV: {ex.Message}";
            return null;
        }
    }

    private byte[] WriteWavHeader(AudioClip clip)
    {
        int fileSize = clip.samples * clip.channels * 2 + 44; // 2 bytes per sample
        int sampleRate = clip.frequency;

        byte[] header = new byte[44];

        // ChunkID "RIFF"
        header[0] = (byte)'R';
        header[1] = (byte)'I';
        header[2] = (byte)'F';
        header[3] = (byte)'F';

        byte[] chunkSize = BitConverter.GetBytes(fileSize - 8);
        Array.Copy(chunkSize, 0, header, 4, 4);

        // Format "WAVE"
        header[8] = (byte)'W';
        header[9] = (byte)'A';
        header[10] = (byte)'V';
        header[11] = (byte)'E';

        byte[] subChunk1Size = BitConverter.GetBytes(16);
        Array.Copy(subChunk1Size, 0, header, 16, 4);

        byte[] audioFormat = BitConverter.GetBytes((short)1);
        Array.Copy(audioFormat, 0, header, 20, 2);

        byte[] numChannels = BitConverter.GetBytes((short)clip.channels);
        Array.Copy(numChannels, 0, header, 22, 2);

        byte[] sampleRateBytes = BitConverter.GetBytes(sampleRate);
        Array.Copy(sampleRateBytes, 0, header, 24, 4);

        byte[] byteRate = BitConverter.GetBytes(sampleRate * clip.channels * 2);
        Array.Copy(byteRate, 0, header, 28, 4);

        byte[] blockAlign = BitConverter.GetBytes((short)(clip.channels * 2));
        Array.Copy(blockAlign, 0, header, 32, 2);

        byte[] bitsPerSample = BitConverter.GetBytes((short)16);
        Array.Copy(bitsPerSample, 0, header, 34, 2);

        // Subchunk2ID "data"
        header[36] = (byte)'d';
        header[37] = (byte)'a';
        header[38] = (byte)'t';
        header[39] = (byte)'a';

        byte[] subChunk2Size = BitConverter.GetBytes(clip.samples * clip.channels * 2);
        Array.Copy(subChunk2Size, 0, header, 40, 4);

        return header;
    }

    private byte[] ConvertAudioClipToPCM(AudioClip clip)
    {
        float[] samples = new float[clip.samples * clip.channels];
        clip.GetData(samples, 0);

        byte[] pcmData = new byte[samples.Length * 2]; // 16-bit PCM, 2 bytes per sample

        for (int i = 0; i < samples.Length; i++)
        {
            short sampleValue = (short)(samples[i] * short.MaxValue);  // Float to 16-bit PCM conversion
            byte[] sampleBytes = BitConverter.GetBytes(sampleValue);
            pcmData[i * 2] = sampleBytes[0];
            pcmData[i * 2 + 1] = sampleBytes[1];
        }

        return pcmData;
    }

    // Google Speech-to-Text 응답 파싱 메서드
    private string ParseResponse(string jsonResponse)
    {
        int startIndex = jsonResponse.IndexOf("\"transcript\": \"") + 15;
        int endIndex = jsonResponse.IndexOf("\"", startIndex);
        return jsonResponse.Substring(startIndex, endIndex - startIndex);
    }
}
