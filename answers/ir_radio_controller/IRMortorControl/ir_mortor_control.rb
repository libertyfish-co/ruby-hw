#
# 赤外線リモコンによるモーター操作
#
require 'pi_piper'
include PiPiper
# =====IR 設定======
# 受信時の記録タイムアウト時間(秒)
RECORDING_TIMEOUT = 1
# 受信時比較の許容一致率
EQUALS_PERSENT = 80
# 時間差比較時に許容する時間差
EQUALS_DIFF = 400
# 末尾比較対象外要素数
END_CUT_COUNT = 20

# ===リモコンとモーター制御の設定===
# 例 リモコンの学習した時間差をそれぞれの定数値に修正して使用する
# 前進   エアコン スイング
FORWARD_TIMINGS = [3281,1597,490,348,445,336,470,1122,597,214,465,1204,404,407,404,340,499,334,401,1182,458,1553,84,340,513,273,466,399,400,1160,466,1189,409,337,471,339,561,297,412,400,402,336,507,342,408,405,443,334,466,334,466,342,600,209,467,333,473,353,400,1189,463,337,472,513,322,336,402,400,401,405,406,392,472,334,465,1143,405,532,272,400,463,337,468,336,471,1165,403,1190,409,1166,603,1055,401,1209,402,1282,338,1179,628,1016,416,1169,401,402,466,1156,465,335,443,335,469,338,439,364,466,1192,401,376,470,335,492,339,401,407,480,371,345,1221,402,364,457,382,405,379,502,315,436,1164,1259,1192,400,401,408,1415,209,1183,400,403,406,401,611,140,515,340,406,407,409,342,503,344,405,401,401,401,406,404,403,424,404,1190,407,390,402,2036,413,344,478,345,415,409,442,337,399,398,469,334,455,339,465,334,551,278,422,413,416,341,441,449,407,335,465,339,476,340,407,406,637,139,468,335,463,401,372,409,405,341,499,339,464,334,469,536,276,406,408,333,467,336,588,206,469,334,431,398,404,406,444,336,468,1187,405,522,272,1162,468,1133,429,405,465,334,468,334,467,1126,471,1183,399,403,401,406,1232,335,467,399,552,206,466,1183,423,333,467,391,401,1183,409,411,450,1161,410,1161,460,1163,470]
# 左     TV戻る
LEFT_TIMINGS = [3421,1674,400,508,343,1188,446,342,513,1124,424,409,401,1206,464,335,465,1154,540,272,471,1221,487,318,411,1199,449,1229,388,452,336,1229,459,368,447,1490,286,1002,452,1193,470,1201,399,400,467,335,467,394,401,1190,399,401,650,989,569,275,405,405,403,1214,467,338,453,337,481,332,467,402,406,403,405,1203,463,335,500,340,456,1186,430,1191,407,1210,467,1189,405,411,406,420,401,400,463,499,276,407,408,407,435,336,464]
# 右     暖かく
RIGHT_TIMINGS = [2069,922,5510,1031,1562,472,535,575,471,473,536,545,511,502,539,471,569,471,558,457,518,518,516,522,534,456,577,440,551,519,539,678,311,1110,95,412,1468,540,474,538,589,405,535,533,538,468,536,638,506,345,541,473,604,472,636,339,603,466,537,468,535,474,538,533,534,472,515,715,427,405,1597,472,537,603,1466,469,1556,467,678,339,1622,469,533,470,534,11338,1955,994,5474,1062,1592,469,534,469,537,534,540,468,537,457,849,207,540,473,550,478,540,467,602,465,534,465,663,401,532,467,532,482,530,578,503,473,1535,509,535,468,604,430,542,517,552,445,600,473,510,470,540,692,355,470,558,469,538,496,539,471,541,515,517,517,575,416,587,510,570,396,1575,469,2614,469,1595,519,537,471,1528,471,745,307,539,11311,1992,996,5456,1072,1531,469,601,467,535,467,739,273,597,467,536,467,535,502,537,493,534,469,533,538,520,469,530,532,563,469,533,465,538,470,700,337,1601,472,537,583,469,467,533,466,600,469,532,469,535,467,600,468,535,510,497,539,541,472,539,514,487,593,472,467,533,467,589,465,529,465,1594,767,283,470,1588,436,1586,496,535,459,1632,471,510,468,604]
# バック  
BACK_TIMINGS = [10000,200000,90000000000000,9000000000000,9000000000000,9000000000000,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9]
# ブレーキ 扇風機 切タイマー
BREAKE_TIMINGS = [9015,4551,533,1914,337,1720,535,602,554,1699,532,648,563,594,395,1836,467,605,533,592,532,662,449,1857,404,654,529,1735,523,1686,537,597,542,1757,525,600,476,1788,524,596,458,1789,517,656,457,658,463,772,337,657,527,1710,529,654,464,1787,488,652,460,1761,655,1634,459,1768,528,1740,495,40183,8975,2307,531,96622,9163,2135,466]

def watch_ir()
  ir_receiver = PiPiper::Pin.new :pin => 4

  puts "watch IR Changed ..."
  before_signal = ir_receiver.read
  loop do
    signal = ir_receiver.read
    if signal != before_signal
      # puts "signal changed."
      captureTimings = read_ir(ir_receiver, signal)
      mortor_order =  convert_ir_to_mortor_order(captureTimings)
      if mortor_order != ""
        send_request(mortor_order)
      end

      puts "watch IR Changed ..."
    end

    before_signal = signal
    # sleep 0.000000001
  end
end

def read_ir(ir_receiver, signal)
  # puts "IR read start ... "
  captureTimings = []
  pre_time = Time.now
  while Time.now - pre_time < RECORDING_TIMEOUT
    if ir_receiver.read != signal
      now_time = Time.now
      captureTimings << now_time - pre_time
      pre_time = now_time
      signal ^= 1
    end
  end
  
  # 先頭のタイミングは削除
  # captureTimings.shift
  captureTimings = captureTimings.map { |timing| (timing*1000000).floor}
  puts "receive result:"
  puts "[#{captureTimings.join(',')}]"
  puts "IR read complete."
  
  return captureTimings
end

def equlsTimings(array1, array2)
  if array1.nil? || array2.nil?
    return false
  end

  if array1.size == 0 || array2.size == 0
    return false
  end

  max = array1.size - END_CUT_COUNT

  result = []
  array1.each_with_index do |value,index|
    break if index == max
    break if index >= array2.size
    diff = value - array2[index]
    diff = diff.abs
  
    if(diff < EQUALS_DIFF)
      result.push(true)
    else
      result.push(false)
    end
  end

  persent = result.count(true) * 100 / result.size.to_f
  
  puts persent
  return persent > EQUALS_PERSENT
end

def convert_ir_to_mortor_order(captureTimings)
  mortor_order = ""
  if equlsTimings(FORWARD_TIMINGS, captureTimings)
    mortor_order = "Forward"
  elsif equlsTimings(LEFT_TIMINGS, captureTimings)
    mortor_order = "Left"
  elsif equlsTimings(RIGHT_TIMINGS, captureTimings)
    mortor_order = "Right"
  elsif equlsTimings(BACK_TIMINGS, captureTimings)
    mortor_order = "Back"
  elsif equlsTimings(BREAKE_TIMINGS, captureTimings)
    mortor_order = "Breake"
  end

  return mortor_order
end

def send_request(function_name)
  puts("send request mortor:" + function_name)
  socket = TCPSocket.open('localhost', 2000)

  socket.puts function_name
  socket.flush
  response = socket.gets
  response if response.present?
rescue
  nil
ensure
  socket.close if socket
end

watch_ir()
