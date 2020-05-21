kubectl apply -f hw2_resources.yaml


sleep 5
ip=$(kubectl get service/csepod -o jsonpath='{.spec.clusterIP}')
#echo "$ip"
end=$((SECONDS+240))
while [ ${SECONDS} -lt ${end} ]; do
  wget $ip -q -O-
done
sleep 5

sed -i -e "s/-v1/-v2/g" hw2_resources.yaml
kubectl apply -f hw2_resources.yaml

#kubectl apply -f hw2_resources_2.yaml
sleep 5
ip=$(kubectl get service/csepod -o jsonpath='{.spec.clusterIP}')
wget $ip -q -O-
sleep 10

kubectl rollout undo deployment.v1.apps/csepod 

sleep 8
ip=$(kubectl get service/csepod -o jsonpath='{.spec.clusterIP}')
wget $ip -q -O- ;


kubectl delete service/csepod  deployment.apps/csepod horizontalpodautoscaler.autoscaling/csepod


sed -i -e "s/-v2/-v1/g" hw2_resources.yaml
echo "Great Success"
