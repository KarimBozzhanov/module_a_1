package com.example.module_a_1;
import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.net.Uri;
import android.provider.MediaStore;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import java.io.IOException;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "javaChannel";
    MediaRecorder mediaRecorder;
    MediaPlayer mediaPlayer;
    private String filePath;




    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if(call.method.equals("startRecording")) {
                        if(this.getPackageManager().hasSystemFeature(PackageManager.FEATURE_MICROPHONE)){
                            filePath = "/sdcard/Download/" + call.argument("fileName") + ".mp3";
                            startRecord();
                        } else {
                            if(ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO)
                                    == PackageManager.PERMISSION_DENIED) {
                                ActivityCompat.requestPermissions(this, new String []
                                        {Manifest.permission.RECORD_AUDIO}, 200);
                            }
                        }
                    } else if(call.method.equals("stopRecording")) {
                        stopRecord();
                        result.success(filePath);
                    } else if(call.method.equals("startPlaying")) {
                        startPlaying(call.argument("recordName"));
                    } else if(call.method.equals("pickImage")) {
                        openGallery();
                        result.success(null);
                    }
                });
    }

    private void openGallery() {
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(intent, 1);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if(requestCode == 1 && resultCode == RESULT_OK && data != null) {
            Uri imageData = data.getData();
            String imagePath = getRealPathFromURI(imageData);
            new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                    .invokeMethod("imageSelected", imagePath);
        }
    }

    private String getRealPathFromURI(Uri imageData) {
        String[] protection = {MediaStore.Images.Media.DATA};
        Cursor cursor = getContentResolver().query(imageData, protection, null, null, null);
        if (cursor == null) return null;
        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
        cursor.moveToFirst();
        String path = cursor.getString(column_index);
        cursor.close();
        return path;
    }

    private void startRecord() {
        try {
            mediaRecorder = new MediaRecorder();
            mediaRecorder.setAudioSource(MediaRecorder.AudioSource.MIC);
            mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP);
            mediaRecorder.setOutputFile(filePath);
            mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB);
            mediaRecorder.prepare();
            mediaRecorder.start();
            Toast.makeText(this, "Recording is started", Toast.LENGTH_SHORT).show();
        } catch (IOException e) {

        }
    }

    private void stopRecord() {
        mediaRecorder.stop();
        mediaRecorder.release();
        mediaRecorder = null;
        Toast.makeText(this, "Recording is stopped", Toast.LENGTH_SHORT).show();
    }

    private void startPlaying(String fileName) {
        try {
            mediaPlayer = new MediaPlayer();
            mediaPlayer.setDataSource(fileName);
            mediaPlayer.prepare();
            mediaPlayer.start();
            Toast.makeText(this, "Recording is played", Toast.LENGTH_SHORT).show();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
