import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.json.JSONObject;

public class UsrjJava {
    public static void main(String[] args) {
        try {
            HttpClient client = HttpClient.newHttpClient();
            
            JSONObject jsonInput = new JSONObject();
            jsonInput.put("name", "John Doe");
            jsonInput.put("age", 30);

            HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://httpbin.org/post"))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(jsonInput.toString()))
                .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            JSONObject jsonResponse = new JSONObject(response.body());
            System.out.println("Response JSON: " + jsonResponse.toString(2));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
