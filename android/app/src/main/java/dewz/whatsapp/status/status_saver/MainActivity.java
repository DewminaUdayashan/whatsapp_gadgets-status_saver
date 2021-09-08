package dewz.whatsapp.status.status_saver;

import android.annotation.SuppressLint;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

import androidx.annotation.NonNull;

import java.util.List;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "DEWZ.STATUS.SAVER";
    private final String TAG = "STATUS_SAVER JAVA => ";
    private final int REQUEST_PERMISSION_CODE = 10000;
    private boolean isPermissionExist = false;
    String uri = "content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fmedia%2Fcom.whatsapp%2FWhatsApp%2FMedia%2F.Statuses";

    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(
                Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        if ("IS_APP_AVAILABLE".equals(call.method)) {
                            final String packageName = call.arguments();
                            result.success(isAppAvailable(packageName));
                        }
                    }
                }
        );

    }

    @SuppressLint("QueryPermissionsNeeded")
    public boolean isAppAvailable(String packageName) {
        PackageManager pm = this.getPackageManager();
        List<ApplicationInfo> list = pm.getInstalledApplications(PackageManager.GET_META_DATA);
        for (ApplicationInfo applicationInfo : list) {
            if (applicationInfo.packageName.equals(packageName)) {
                return true;
            }
        }
        return false;
    }
}
